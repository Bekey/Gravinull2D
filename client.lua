local client = lube.udpClient()

function client.onReceive(data)
	local t = loadstring(data)()
end

client.handshake = "DEA PRO MIHI, AUDITE MEUS DICO. PATEFACIO PRODIGIUM PRO NOS TOTUS."
client.callbacks.recv = client.onReceive



return client