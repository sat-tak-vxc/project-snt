import subprocess

#作成するスクラッチ組織の数を指定
createScrachNum = input("作成するスクラッチ組織の数を入力してください。:")
print(createScrachNum+" 個のスクラッチ組織を作成します。")

TEXT_DEVHUB = 'production'
COMAND_CREATE_SCRACH = "sfdx force:org:create -f config\project-scratch-def.json -d 30 -w 10 -v {} -s".format(TEXT_DEVHUB)
print(COMAND_CREATE_SCRACH)
f = open('scrachInfo.text', 'w')
dataList = []
try:
    for n in range(int(createScrachNum)):
        dataList.append("--スクラッチ組織{}--\n".format(n))
        print("--スクラッチ組織{}--\n".format(n))
        results = subprocess.run(COMAND_CREATE_SCRACH ,shell=True , capture_output=True, text=True , encoding = 'UTF-8').stdout.split()
        #print("CreateComand:result==>{}".format(results))
        #print("Reslt==>{}".format(results[0]))
        outputUserId = ""
        nextReslut = False
        if results[0] != "Successfully" :
            #print("ERROR")
            exit()
        for result in results :
            if nextReslut == True :
                outputUserId = result[:-1]
                #print("UserName==>{}".format(outputUserId))
                break
            
            if result == "username:":
                nextReslut = True
                

        COMAND_CHANGE_PASS = "sfdx force:user:password:generate --targetusername {}".format(outputUserId)
        print("COMAND_CREATE_SCRACH:{}".format(COMAND_CHANGE_PASS))
        results = subprocess.run(COMAND_CHANGE_PASS ,shell=True ,capture_output=True, text=True,encoding = 'UTF-8').stdout.split()
        print("ChangePasswordComand:result==>{}".format(results))
        print("Reslt==>{}".format(results[0]))

        outputPassword = ""
        nextReslut = False
        if results[0] != "Successfully" :
            print("ERROR")
            exit()
        for result in results :
            if nextReslut == True :
                outputPassword = result
                break

            if result == "password":
                nextReslut = True
                

        COMAND_INPORT_APP1 = "sfdx force:package:install -p 04t2r000000ka7MAAQ -s AllUsers -r -u {} -b 10 -w 10".format(outputUserId)
        results = subprocess.run(COMAND_INPORT_APP1 ,shell=True ,capture_output=True, text=True,encoding = 'UTF-8').stdout.split()

        COMAND_INPORT_APP2 = "sfdx force:package:install -p 04t5h000000LxCQAA0 -s AllUsers -r -u {} -b 10 -w 10".format(outputUserId)
        results = subprocess.run(COMAND_INPORT_APP2 ,shell=True ,capture_output=True, text=True,encoding = 'UTF-8').stdout.split()

        COMAND_INPORT_APP3 = "sfdx force:package:install -p 04t10000000K8DRAA0 -s AllUsers -r -u {} -b 10 -w 10".format(outputUserId)  
        results = subprocess.run(COMAND_INPORT_APP3 ,shell=True ,capture_output=True, text=True,encoding = 'UTF-8').stdout.split()

        dataList.append("UserName:{}\n".format(outputUserId))
        dataList.append("Password:{}\n".format(outputPassword))
        print('----------------------')
except IndexError :
    print("SYSTEM ERROR")
f.writelines(dataList)
f.close()
print(dataList)