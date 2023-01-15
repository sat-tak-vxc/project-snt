/**
 * 
 * @author 
 * @since 
 */
@isTest(SeeAllData=true)
private class DeletePersonalInfoFlowActionTest {
    /**
     * 取引先レコードタイプ：委託企業
     */
    /*
    @isTest
    static void deletePersonalInfo_001() {
        // テスト対象取引先ID
        String accountId = '90000001a';

        // データ生成
        DeletePersonalInfoTestDataFactory.createAccount_Mass_TraderSelection(1, 'メール');

        List<Account> accountEexpecteds = [
            SELECT
                Id,
                RecordTypeId,
                IsContractPossible__c,
                ContractCategory__c,
                AccountAbbreviation__c,
                Representative__c,
                ContractMoneyDeadline__c,
                ContractMoneyBillingDate__c,
                ContractTermStartDate__c,
                ContractTermEndDate__c,
                ContractorCopied__c,
                ConsignmentCollectionNew__c,
                ConsignmentCollectionCancel__c,
                ContractSignatureRepresentative__c,
                ContractMailOperatingCostsNote__c,
                PracticeChargeEmail1__c,
                PracticeChargeEmail2__c,
                WorkPlacePhone__c,
                AcceptForContactRealEstatePhone__c
            FROM Account
            WHERE AccountId__c = :accountId
        ];

        List<Contact> contactEexpecteds = [
            SELECT
                Id,
                OtherDestinationCategory__c,
                CompanyStaffCharacteristic__c,
                Character__c,
                Department,
                OtherPriorityRanking__c,
                EmailContactRanking__c,
                InaugurationDate__c,
                RetireDate__c,
                HasOptedOutOfFax,
                HasOptedOutOfEmail,
                IsNoResident__c,
                TransferMemo__c,
                Description,
                Email,
                Email2__c,
                MobilePhone,
                Mobile2__c
            FROM Contact
            WHERE AccountId = :accountEexpecteds.get(0).Id
        ];

        List<User> userEexpecteds = [
            SELECT
                Id,
                IsActive
            FROM User
            WHERE Contact.AccountId = :accountEexpecteds.get(0).Id
        ];

        Test.startTest();
        List<DeletePersonalInfoFlowAction.Request> requests = new List<DeletePersonalInfoFlowAction.Request>();
        DeletePersonalInfoFlowAction.Request request = new DeletePersonalInfoFlowAction.Request();
        request.accountId = accountEexpecteds.get(0).Id;
        request.recordTypeId = accountEexpecteds.get(0).RecordTypeId;
        requests.add(request);
        DeletePersonalInfoFlowAction.deletePersonalInfo(requests);
        Test.stopTest();

        List<Account> accountActuals = [
            SELECT
                Id,
                RecordTypeId,
                IsContractPossible__c,
                ContractCategory__c,
                AccountAbbreviation__c,
                Representative__c,
                ContractMoneyDeadline__c,
                ContractMoneyBillingDate__c,
                ContractTermStartDate__c,
                ContractTermEndDate__c,
                ContractorCopied__c,
                ConsignmentCollectionNew__c,
                ConsignmentCollectionCancel__c,
                ContractSignatureRepresentative__c,
                ContractMailOperatingCostsNote__c,
                PracticeChargeEmail1__c,
                PracticeChargeEmail2__c,
                WorkPlacePhone__c,
                AcceptForContactRealEstatePhone__c
            FROM Account
            WHERE AccountId__c = :accountId
        ];

        System.assertEquals(accountEexpecteds.get(0).Id, accountActuals.get(0).Id);
        System.assertEquals(accountEexpecteds.get(0).RecordTypeId, accountActuals.get(0).RecordTypeId);

        List<Contact> contactActuals = [
            SELECT
                Id,
                OtherDestinationCategory__c,
                CompanyStaffCharacteristic__c,
                Character__c,
                Department,
                OtherPriorityRanking__c,
                EmailContactRanking__c,
                InaugurationDate__c,
                RetireDate__c,
                HasOptedOutOfFax,
                HasOptedOutOfEmail,
                IsNoResident__c,
                TransferMemo__c,
                Description,
                Email,
                Email2__c,
                MobilePhone,
                Mobile2__c
            FROM Contact
            WHERE AccountId = :accountActuals.get(0).Id
        ];

        System.assertEquals(contactEexpecteds.get(0).Id, contactActuals.get(0).Id);

        List<User> userActuals = [
            SELECT
                Id,
                IsActive
            FROM User
            WHERE Contact.AccountId = :accountActuals.get(0).Id
        ];

        System.assertEquals(userEexpecteds.get(0).Id, userActuals.get(0).Id);
        System.assertEquals(false, userActuals.get(0).IsActive);
    }
    */
    /**
     * 取引先レコードタイプ：不動産会社/家主
     */
    /*
    @isTest
    static void deletePersonalInfo_002() {
        // テスト対象取引先ID
        String accountId = '90000001b';

        // データ生成
        DeletePersonalInfoTestDataFactory.createAccount_Mass_TraderSelection(1, 'メール');

        List<Account> accountEexpecteds = [
            SELECT
                Id,
                RecordTypeId,
                IsContractPossible__c,
                ContractCategory__c,
                AccountAbbreviation__c,
                Representative__c,
                ContractMoneyDeadline__c,
                ContractMoneyBillingDate__c,
                ContractTermStartDate__c,
                ContractTermEndDate__c,
                ContractorCopied__c,
                ConsignmentCollectionNew__c,
                ConsignmentCollectionCancel__c,
                ContractSignatureRepresentative__c,
                ContractMailOperatingCostsNote__c,
                PracticeChargeEmail1__c,
                PracticeChargeEmail2__c,
                WorkPlacePhone__c,
                AcceptForContactRealEstatePhone__c
            FROM Account
            WHERE AccountId__c = :accountId
        ];

        Test.startTest();
        List<DeletePersonalInfoFlowAction.Request> requests = new List<DeletePersonalInfoFlowAction.Request>();
        DeletePersonalInfoFlowAction.Request request = new DeletePersonalInfoFlowAction.Request();
        request.accountId = accountEexpecteds.get(0).Id;
        request.recordTypeId = accountEexpecteds.get(0).RecordTypeId;
        requests.add(request);
        DeletePersonalInfoFlowAction.deletePersonalInfo(requests);
        Test.stopTest();

        List<Account> accountActuals = [
            SELECT
                Id,
                RecordTypeId,
                IsContractPossible__c,
                ContractCategory__c,
                AccountAbbreviation__c,
                Representative__c,
                ContractMoneyDeadline__c,
                ContractMoneyBillingDate__c,
                ContractTermStartDate__c,
                ContractTermEndDate__c,
                ContractorCopied__c,
                ConsignmentCollectionNew__c,
                ConsignmentCollectionCancel__c,
                ContractSignatureRepresentative__c,
                ContractMailOperatingCostsNote__c,
                PracticeChargeEmail1__c,
                PracticeChargeEmail2__c,
                WorkPlacePhone__c,
                AcceptForContactRealEstatePhone__c
            FROM Account
            WHERE AccountId__c = :accountId
        ];

        System.assertEquals(accountEexpecteds.get(0).Id, accountActuals.get(0).Id);
        System.assertEquals(accountEexpecteds.get(0).RecordTypeId, accountActuals.get(0).RecordTypeId);

        // System.assertEquals(accountEexpecteds.get(0).IsContractPossible__c, accountActuals.get(0).IsContractPossible__c);
        // System.assertEquals('1', accountActuals.get(0).ContractCategory__c);
        // System.assertEquals(accountEexpecteds.get(0).AccountAbbreviation__c, accountActuals.get(0).AccountAbbreviation__c);
        // System.assertEquals('○○', accountActuals.get(0).Representative__c);
        // System.assertEquals(accountEexpecteds.get(0).ContractMoneyDeadline__c, accountActuals.get(0).ContractMoneyDeadline__c);
        // System.assertEquals(Decimal.valueOf('99'), accountActuals.get(0).ContractMoneyBillingDate__c);
        // System.assertEquals(accountEexpecteds.get(0).ContractTermStartDate__c, accountActuals.get(0).ContractTermStartDate__c);
        // System.assertEquals(Date.valueOf('4000-12-31'), accountActuals.get(0).ContractTermEndDate__c);
        // System.assertEquals(accountEexpecteds.get(0).ContractorCopied__c, accountActuals.get(0).ContractorCopied__c);
        // System.assertEquals(false, accountActuals.get(0).ConsignmentCollectionNew__c);
        // System.assertEquals(accountEexpecteds.get(0).ConsignmentCollectionCancel__c, accountActuals.get(0).ConsignmentCollectionCancel__c);
        // System.assertEquals(null, accountActuals.get(0).ContractSignatureRepresentative__c);
        // System.assertEquals(accountEexpecteds.get(0).ContractMailOperatingCostsNote__c, accountActuals.get(0).ContractMailOperatingCostsNote__c);
        // System.assertEquals(null, accountActuals.get(0).PracticeChargeEmail1__c);
        // System.assertEquals(accountEexpecteds.get(0).PracticeChargeEmail2__c, accountActuals.get(0).PracticeChargeEmail2__c);
        // System.assertEquals(null, accountActuals.get(0).WorkPlacePhone__c);
        // System.assertEquals('0300000000', accountActuals.get(0).AcceptForContactRealEstatePhone__c);
    }
    */
    /**
     * 取引先レコードタイプ：引越業者
     */
    /*
    @isTest
    static void deletePersonalInfo_003() {
        // テスト対象取引先ID
        String accountId = '90000001c';

        // データ生成
        DeletePersonalInfoTestDataFactory.createAccount_Mass_TraderSelection(1, 'メール');

        List<Account> accountEexpecteds = [
            SELECT
                Id,
                RecordTypeId,
                IsContractPossible__c,
                ContractCategory__c,
                AccountAbbreviation__c,
                Representative__c,
                ContractMoneyDeadline__c,
                ContractMoneyBillingDate__c,
                ContractTermStartDate__c,
                ContractTermEndDate__c,
                ContractorCopied__c,
                ConsignmentCollectionNew__c,
                ConsignmentCollectionCancel__c,
                ContractSignatureRepresentative__c,
                ContractMailOperatingCostsNote__c,
                PracticeChargeEmail1__c,
                PracticeChargeEmail2__c,
                WorkPlacePhone__c,
                AcceptForContactRealEstatePhone__c
            FROM Account
            WHERE AccountId__c = :accountId
        ];

        Test.startTest();
        List<DeletePersonalInfoFlowAction.Request> requests = new List<DeletePersonalInfoFlowAction.Request>();
        DeletePersonalInfoFlowAction.Request request = new DeletePersonalInfoFlowAction.Request();
        request.accountId = accountEexpecteds.get(0).Id;
        request.recordTypeId = accountEexpecteds.get(0).RecordTypeId;
        requests.add(request);
        DeletePersonalInfoFlowAction.deletePersonalInfo(requests);
        Test.stopTest();

        List<Account> accountActuals = [
            SELECT
                Id,
                RecordTypeId,
                IsContractPossible__c,
                ContractCategory__c,
                AccountAbbreviation__c,
                Representative__c,
                ContractMoneyDeadline__c,
                ContractMoneyBillingDate__c,
                ContractTermStartDate__c,
                ContractTermEndDate__c,
                ContractorCopied__c,
                ConsignmentCollectionNew__c,
                ConsignmentCollectionCancel__c,
                ContractSignatureRepresentative__c,
                ContractMailOperatingCostsNote__c,
                PracticeChargeEmail1__c,
                PracticeChargeEmail2__c,
                WorkPlacePhone__c,
                AcceptForContactRealEstatePhone__c
            FROM Account
            WHERE AccountId__c = :accountId
        ];
        System.assertEquals(accountEexpecteds.get(0).Id, accountActuals.get(0).Id);
        System.assertEquals(accountEexpecteds.get(0).RecordTypeId, accountActuals.get(0).RecordTypeId);

        // System.assertEquals(accountEexpecteds.get(0).IsContractPossible__c, accountActuals.get(0).IsContractPossible__c);
        // System.assertEquals(accountEexpecteds.get(0).ContractCategory__c, accountActuals.get(0).ContractCategory__c);
        // System.assertEquals(null, accountActuals.get(0).AccountAbbreviation__c);
        // System.assertEquals('○○', accountActuals.get(0).Representative__c);
        // System.assertEquals(accountEexpecteds.get(0).ContractMoneyDeadline__c, accountActuals.get(0).ContractMoneyDeadline__c);
        // System.assertEquals(accountEexpecteds.get(0).ContractMoneyBillingDate__c, accountActuals.get(0).ContractMoneyBillingDate__c);
        // System.assertEquals(null, accountActuals.get(0).ContractTermStartDate__c);
        // System.assertEquals(Date.valueOf('4000-12-31'), accountActuals.get(0).ContractTermEndDate__c);
        // System.assertEquals(accountEexpecteds.get(0).ContractorCopied__c, accountActuals.get(0).ContractorCopied__c);
        // System.assertEquals(accountEexpecteds.get(0).ConsignmentCollectionNew__c, accountActuals.get(0).ConsignmentCollectionNew__c);
        // System.assertEquals(false, accountActuals.get(0).ConsignmentCollectionCancel__c);
        // System.assertEquals(null, accountActuals.get(0).ContractSignatureRepresentative__c);
        // System.assertEquals(accountEexpecteds.get(0).ContractMailOperatingCostsNote__c, accountActuals.get(0).ContractMailOperatingCostsNote__c);
        // System.assertEquals(accountEexpecteds.get(0).PracticeChargeEmail1__c, accountActuals.get(0).PracticeChargeEmail1__c);
        // System.assertEquals('xxx@xxx.xxx', accountActuals.get(0).PracticeChargeEmail2__c);
        // System.assertEquals(null, accountActuals.get(0).WorkPlacePhone__c);
        // System.assertEquals('0300000000', accountActuals.get(0).AcceptForContactRealEstatePhone__c);
    }
    */
}