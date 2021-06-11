import { Timestamp } from 'google-protobuf/google/protobuf/timestamp_pb';

declare namespace chat {
  type chatMessage = {
    message: string;
    timestamp: Timestamp;
  };
}
