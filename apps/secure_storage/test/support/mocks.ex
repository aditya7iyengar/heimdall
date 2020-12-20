require Mox

Mox.defmock(
  SecureStorage.EncryptedMessagesMock,
  for: SecureStorage.EncryptedMessagesContext
)

Mox.defmock(
  SecureStorage.ChatRoomsMock,
  for: SecureStorage.ChatRoomsContext
)
