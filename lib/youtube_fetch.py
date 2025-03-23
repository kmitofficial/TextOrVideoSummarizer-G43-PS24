import requests
import json
import time
import firebase_admin
from firebase_admin import credentials, messaging
from dotenv import load_dotenv
import os

dotenv_path = os.path.join(os.path.dirname(__file__), '..', 'assets', '.env')

load_dotenv(dotenv_path)

print(f"Loaded .env file from: {dotenv_path}")

FCM_CREDENTIALS = os.getenv('FCM_CREDENTIALS')
API_KEY = os.getenv('API_KEY')
CHANNEL_ID = os.getenv('CHANNEL_ID')
FCM_REGISTRATION_TOKEN = os.getenv('FCM_REGISTRATION_TOKEN')

if not FCM_CREDENTIALS:
    raise ValueError('FCM_CREDENTIALS environment variable not set')
if not API_KEY:
    raise ValueError('API_KEY environment variable not set')
if not CHANNEL_ID:
    raise ValueError('CHANNEL_ID environment variable not set')
if not FCM_REGISTRATION_TOKEN:
    raise ValueError('FCM_REGISTRATION_TOKEN environment variable not set')

cred = credentials.Certificate(FCM_CREDENTIALS)
firebase_admin.initialize_app(cred)

def get_latest_video(api_key, channel_id):
    url = f"https://www.googleapis.com/youtube/v3/search?key={api_key}&channelId={channel_id}&part=snippet,id&order=date&maxResults=1"
    response = requests.get(url)
    if response.status_code == 200:
        data = response.json()
        if 'items' in data and len(data['items']) > 0:
            latest_video = data['items'][0]
            video_id = latest_video['id']['videoId']
            title = latest_video['snippet']['title']
            description = latest_video['snippet']['description']
            return {
                'video_id': video_id,
                'title': title,
                'description': description
            }
    return None

def send_notification(token, title):
    message = messaging.Message(
        notification=messaging.Notification(
            title='New YouTube Video Uploaded!',
            body=title,
        ),
        token=token,
    )

    try:
        response = messaging.send(message)
        print('Successfully sent message:', response)
    except Exception as e:
        print('Error sending message:', e)

def main():
    last_video_id = None
    while True:
        latest_video = get_latest_video(API_KEY, CHANNEL_ID)
        if latest_video:
            video_id = latest_video['video_id']
            if video_id != last_video_id:
                send_notification(FCM_REGISTRATION_TOKEN, latest_video['title'])
                last_video_id = video_id
        time.sleep(600) 

if __name__ == "__main__":
    main()
