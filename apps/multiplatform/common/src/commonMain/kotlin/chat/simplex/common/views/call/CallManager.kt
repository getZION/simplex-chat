package chat.simplex.common.views.call

import chat.simplex.common.model.ChatModel
import chat.simplex.common.platform.*
import chat.simplex.common.views.helpers.withApi
import kotlinx.datetime.Clock
import kotlin.time.Duration.Companion.minutes

class CallManager(val chatModel: ChatModel) {
  fun reportNewIncomingCall(invitation: RcvCallInvitation) {
    Log.d(TAG, "CallManager.reportNewIncomingCall")
    with (chatModel) {
      callInvitations[invitation.contact.id] = invitation
      if (invitation.user.showNotifications) {
        if (Clock.System.now() - invitation.callTs <= 3.minutes) {
          activeCallInvitation.value = invitation
          ntfManager.notifyCallInvitation(invitation)
        } else {
          val contact = invitation.contact
          ntfManager.displayNotification(user = invitation.user, chatId = contact.id, displayName = contact.displayName, msgText = invitation.callTypeText)
        }
      }
    }
  }

  fun acceptIncomingCall(invitation: RcvCallInvitation) {
    val call = chatModel.activeCall.value
    if (call == null) {
      justAcceptIncomingCall(invitation = invitation)
    } else {
      withApi {
        chatModel.switchingCall.value = true
        try {
          endCall(call = call)
          justAcceptIncomingCall(invitation = invitation)
        } finally {
          withApi { chatModel.switchingCall.value = false }
        }
      }
    }
  }

  private fun justAcceptIncomingCall(invitation: RcvCallInvitation) {
    with (chatModel) {
      activeCall.value = Call(
        remoteHostId = invitation.remoteHostId,
        contact = invitation.contact,
        callState = CallState.InvitationAccepted,
        localMedia = invitation.callType.media,
        sharedKey = invitation.sharedKey,
      )
      showCallView.value = true
      val useRelay = controller.appPrefs.webrtcPolicyRelay.get()
      val iceServers = getIceServers()
      Log.d(TAG, "answerIncomingCall iceServers: $iceServers")
      callCommand.add(WCallCommand.Start(
        media = invitation.callType.media,
        aesKey = invitation.sharedKey,
        iceServers = iceServers,
        relay = useRelay
      ))
      callInvitations.remove(invitation.contact.id)
      if (invitation.contact.id == activeCallInvitation.value?.contact?.id) {
        activeCallInvitation.value = null
        ntfManager.cancelCallNotification()
      }
    }
  }

  suspend fun endCall(call: Call) {
    with (chatModel) {
      if (call.callState == CallState.Ended) {
        Log.d(TAG, "CallManager.endCall: call ended")
        activeCall.value = null
        showCallView.value = false
      } else {
        Log.d(TAG, "CallManager.endCall: ending call...")
        callCommand.add(WCallCommand.End)
        showCallView.value = false
        controller.apiEndCall(call.remoteHostId, call.contact)
        activeCall.value = null
      }
    }
  }

  fun endCall(invitation: RcvCallInvitation) {
    with (chatModel) {
      callInvitations.remove(invitation.contact.id)
      if (invitation.contact.id == activeCallInvitation.value?.contact?.id) {
        activeCallInvitation.value = null
        ntfManager.cancelCallNotification()
      }
      withApi {
        if (!controller.apiRejectCall(invitation.remoteHostId, invitation.contact)) {
          Log.e(TAG, "apiRejectCall error")
        }
      }
    }
  }

  fun reportCallRemoteEnded(invitation: RcvCallInvitation) {
    if (chatModel.activeCallInvitation.value?.contact?.id == invitation.contact.id) {
      chatModel.activeCallInvitation.value = null
      ntfManager.cancelCallNotification()
    }
  }
}
