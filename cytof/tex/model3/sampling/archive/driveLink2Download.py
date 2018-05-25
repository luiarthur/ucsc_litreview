import urllib
import re

getID = re.compile('\id=.*')

def driveLink2Download(dlink):
    header = "https://docs.google.com/uc?export=download&"
    ID = getID.findall(dlink)[0]
    url_download = header + ID
    urllib.urlretrieve(url_download, "img.zip")

#dlink2download('https://drive.google.com/open?id=1K5gTYqiDkZvXLpCIDPO6PYCsbL8Wx1Qe')
