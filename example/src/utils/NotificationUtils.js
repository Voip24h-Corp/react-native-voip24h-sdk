import notifee, { AndroidCategory, AndroidImportance, EventType} from '@notifee/react-native';
import { SipModule, SipConfigurationBuilder, TransportType } from 'react-native-voip24h-sdk'

const ID_CHANNEL = "incoming_call"
const ID_NOTIFICATION = "incoming_call_notification"
const ID_ACTION_ANSWER = "answer"
const ID_ACTION_REJECT = "reject"

export const NotificationUtils = {
    displayIncomingCallNotification: async (phone) => {
      const channelId = await notifee.createChannel({
          id: ID_CHANNEL,
          name: 'Default Channel',
      });
      // Display a notification
      await notifee.displayNotification({
        id: ID_NOTIFICATION,
        title: 'Incoming Call',
        body: phone,
        android: {
          channelId,
          importance: AndroidImportance.HIGH,
          category: AndroidCategory.CALL,
          autoCancel: true,
          ongoing: true,
          pressAction: {
            id: 'default',
            launchActivity: 'default',
          },
          actions: [
            {
              title: 'Answer',
              pressAction: {
                id: ID_ACTION_ANSWER
              },
            },
            {
              title: 'Reject',
              pressAction: {
                id: ID_ACTION_REJECT
              },
            },
          ]
        },
      });
    },
    handleClickToNotification: async (event) => {
      console.log(`Event notifee background: ${event.type}`)
      if (event.type === EventType.ACTION_PRESS) {
        console.log('onBackgroundEvent - ' + event.detail.pressAction.id)
        switch (event.detail.pressAction.id) {
          case ID_ACTION_ANSWER:
            SipModule.acceptCall();
            break;
          case ID_ACTION_REJECT:
            SipModule.decline();
            break;
        }
        await notifee.cancelNotification('incoming_call')
      }
    },
    observeNotifitionForegroundForAndroid: () => {
      notifee.onForegroundEvent(async event => {
        NotificationUtils.handleClickToNotification(event)
      })
    },
    observeNotifitionBackgroundForAndroid: () => {
      notifee.onBackgroundEvent(async event => {
        NotificationUtils.handleClickToNotification(event)
      });
    }
}