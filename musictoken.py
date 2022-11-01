import datetime
import jwt


secret = """-----BEGIN PRIVATE KEY-----
MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgzIiaW8CwKTq6iDsn
07PC6d9i26k9CsQT8gni64/+80mgCgYIKoZIzj0DAQehRANCAATU1UsOTn0Yd7JF
bhAPqRWqy0D8qlJGne9ErmczMm0vANurFhnDX257v7FNoIKVkZ/yiPabSgUD9rJ0
ExOUx22c
-----END PRIVATE KEY-----"""
keyId = "8P8FA32J33"
teamId = "S59HYY3L5C"
alg = 'ES256'

time_now = datetime.datetime.now()
time_expired = datetime.datetime.now() + datetime.timedelta(hours=4380)

headers = {
	"alg": alg,
	"kid": keyId
}

payload = {
	"iss": teamId,
	"exp": int(time_expired.strftime("%s")),
	"iat": int(time_now.strftime("%s"))
}


if __name__ == "__main__":
	"""Create an auth token"""
	token = jwt.encode(payload, secret, algorithm=alg, headers=headers)

	print ("----TOKEN----")
	print (token)

	print ("----CURL----")
	print ("curl -v -H 'Authorization: Bearer %s' \"https://api.music.apple.com/v1/catalog/us/artists/36954\" " % (token))

