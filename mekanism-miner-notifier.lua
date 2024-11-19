local modem = peripheral.wrap("top")
modem.open(2137)
while true do
  local _, _, _, _, message, _ = os.pullEvent("modem_message")
  print(message)
end
