import grpc
from google.protobuf.timestamp_pb2 import Timestamp
from proto import messenger_pb2
from proto import messenger_pb2_grpc
from time import sleep


if __name__ == "__main__":
    for retry in range(5):
        try:
            with grpc.insecure_channel('localhost:10000') as channel:
                # Post "Hello" message first
                stub = messenger_pb2_grpc.MessengerStub(channel)
                stub.PostMessage(messenger_pb2.MessageRequest(message="Hello"))

                # Then keep receiving messages
                for res in stub.FetchMessage(messenger_pb2.MessageResponse()):
                    msg: str = res.message
                    ts: Timestamp = res.timestamp
                    formatted_ts = ts.ToDatetime().strftime("%Y/%m/%d %H:%M:%S")
                    print(f"{res.message} ({formatted_ts})")
        except (KeyboardInterrupt, SystemExit):
            print('Shutting down gracefully...')
            break
        except Exception as err:
            print(f'Unexpected error caused. retry:{retry} <{type(err)}> {err}')
            sleep(1)
