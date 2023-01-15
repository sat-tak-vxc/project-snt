import subprocess
import time

deleateList= []



TEXT_DEVHUB = 'production'
COMAND_DELEATE_SCRACH = "sfdx force:org:delete -u {}".format(TEXT_DEVHUB)
print("DO COMAND:{}".format(COMAND_DELEATE_SCRACH))

for deleateUser in deleateList:
    print("USER:{}=>DELEATE".format(deleateUser))
    print(subprocess.run(COMAND_DELEATE_SCRACH ,shell=True , capture_output=True, text=True).stdout)
    time.sleep(2)
    print(subprocess.run("y" ,shell=True , capture_output=True, text=True).stdout)
