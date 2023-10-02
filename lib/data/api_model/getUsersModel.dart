class GetUserModels {
  num? id;
  String? username;
  String? email;
  String? balance;
  String? userType;
  num? fleetID;
  String? profilePic;
  num? isActive;
  num? agreement;
  num? copyright;
  String? createdAt;
  String? updatedAt;
  Fleet? fleet;
  num? corporate;
  String? rentalType;
  String? unpaidBalance;

  GetUserModels(
      {this.id,
      this.username,
      this.email,
      this.balance,
      this.userType,
      this.fleetID,
      this.profilePic,
      this.isActive,
      this.agreement,
      this.copyright,
      this.createdAt,
      this.updatedAt,
      this.fleet,
      this.corporate,
      this.rentalType,
      this.unpaidBalance});

  GetUserModels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    balance = json['balance'];
    userType = json['userType'];
    fleetID = json['fleetID'];
    profilePic = json['ProfilePic'];
    isActive = json['isActive'];
    agreement = json['agreement'];
    copyright = json['copyright'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    fleet = json['fleet'] != null ? new Fleet.fromJson(json['fleet']) : null;
    corporate = json['corporate'];
    rentalType = json['rental_type'];
    unpaidBalance = json['unpaid_balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['balance'] = this.balance;
    data['userType'] = this.userType;
    data['fleetID'] = this.fleetID;
    data['ProfilePic'] = this.profilePic;
    data['isActive'] = this.isActive;
    data['agreement'] = this.agreement;
    data['copyright'] = this.copyright;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.fleet != null) {
      data['fleet'] = this.fleet!.toJson();
    }
    data['corporate'] = this.corporate;
    data['rental_type'] = this.rentalType;
    data['unpaid_balance'] = this.unpaidBalance;
    return data;
  }
}

class Fleet {
  num? fleetId;
  String? fleetName;
  String? fleetLicenseNumber;
  String? fleetLicenseState;
  String? googleAddress;
  String? fleetAddress;
  String? fleetStreet;
  String? fleetRoute;
  String? fleetCity;
  String? fleetState;
  String? fleetPost;
  String? fleetCountry;
  String? fleetABN;
  String? fleetCustomerNumber;
  String? fleetPhoneO;
  String? fleetPhoneM;
  String? fleetPhoneF;
  String? fleetLogo;
  String? fleetEmailid;
  String? fleetWebsite;
  String? fleetOwnerName;
  String? fleetOwnerEmail;
  String? fleetOwnerMobile;
  String? fleetManagerName;
  String? fleetManagerEmail;
  String? fleetManagerMobile;
  String? fleetAccountName;
  String? fleetAccountEmail;
  String? fleetAccountMobile;
  String? fleetManagerSignature;
  String? fleetTechnicalName;
  String? fleetTechnicalEmail;
  String? fleetTechnicalMobile;
  String? fleetLawyerName;
  String? fleetLawyerEmail;
  String? fleetLawyerMobile;
  String? rentalCompanyAbn;
  String? rentalCompanyName;
  String? termsNConditions;
  String? fleetVehicleOwner;
  String? bpayCrn;
  String? ccToken;
  num? agreementCounter;
  double? balance;
  String? trackerBalance;
  String? rentalType;
  num? status;
  String? goLive;
  String? bankProcess;
  String? isDeleted;
  num? inCollection;
  num? agentId;
  String? collectionReference;
  num? defaultNotice;
  num? hasSetupRevenue;
  num? trackerType;
  String? createdAt;
  String? updatedAt;
  num? outstanding;

  Fleet(
      {this.fleetId,
      this.fleetName,
      this.fleetLicenseNumber,
      this.fleetLicenseState,
      this.googleAddress,
      this.fleetAddress,
      this.fleetStreet,
      this.fleetRoute,
      this.fleetCity,
      this.fleetState,
      this.fleetPost,
      this.fleetCountry,
      this.fleetABN,
      this.fleetCustomerNumber,
      this.fleetPhoneO,
      this.fleetPhoneM,
      this.fleetPhoneF,
      this.fleetLogo,
      this.fleetEmailid,
      this.fleetWebsite,
      this.fleetOwnerName,
      this.fleetOwnerEmail,
      this.fleetOwnerMobile,
      this.fleetManagerName,
      this.fleetManagerEmail,
      this.fleetManagerMobile,
      this.fleetAccountName,
      this.fleetAccountEmail,
      this.fleetAccountMobile,
      this.fleetManagerSignature,
      this.fleetTechnicalName,
      this.fleetTechnicalEmail,
      this.fleetTechnicalMobile,
      this.fleetLawyerName,
      this.fleetLawyerEmail,
      this.fleetLawyerMobile,
      this.rentalCompanyAbn,
      this.rentalCompanyName,
      this.termsNConditions,
      this.fleetVehicleOwner,
      this.bpayCrn,
      this.ccToken,
      this.agreementCounter,
      this.balance,
      this.trackerBalance,
      this.rentalType,
      this.status,
      this.goLive,
      this.bankProcess,
      this.isDeleted,
      this.inCollection,
      this.agentId,
      this.collectionReference,
      this.defaultNotice,
      this.hasSetupRevenue,
      this.trackerType,
      this.createdAt,
      this.updatedAt,
      this.outstanding});

  Fleet.fromJson(Map<String, dynamic> json) {
    fleetId = json['fleet_id'];
    fleetName = json['fleet_name'];
    fleetLicenseNumber = json['fleet_license_number'];
    fleetLicenseState = json['fleet_license_state'];
    googleAddress = json['google_address'];
    fleetAddress = json['fleet_address'];
    fleetStreet = json['fleet_street'];
    fleetRoute = json['fleet_route'];
    fleetCity = json['fleet_city'];
    fleetState = json['fleet_state'];
    fleetPost = json['fleet_post'];
    fleetCountry = json['fleet_country'];
    fleetABN = json['fleet_ABN'];
    fleetCustomerNumber = json['fleet_customer_number'];
    fleetPhoneO = json['fleet_phone_o'];
    fleetPhoneM = json['fleet_phone_m'];
    fleetPhoneF = json['fleet_phone_f'];
    fleetLogo = json['fleet_logo'];
    fleetEmailid = json['fleet_emailid'];
    fleetWebsite = json['fleet_website'];
    fleetOwnerName = json['fleet_owner_name'];
    fleetOwnerEmail = json['fleet_owner_email'];
    fleetOwnerMobile = json['fleet_owner_mobile'];
    fleetManagerName = json['fleet_manager_name'];
    fleetManagerEmail = json['fleet_manager_email'];
    fleetManagerMobile = json['fleet_manager_mobile'];
    fleetAccountName = json['fleet_account_name'];
    fleetAccountEmail = json['fleet_account_email'];
    fleetAccountMobile = json['fleet_account_mobile'];
    fleetManagerSignature = json['fleet_manager_signature'];
    fleetTechnicalName = json['fleet_technical_name'];
    fleetTechnicalEmail = json['fleet_technical_email'];
    fleetTechnicalMobile = json['fleet_technical_mobile'];
    fleetLawyerName = json['fleet_lawyer_name'];
    fleetLawyerEmail = json['fleet_lawyer_email'];
    fleetLawyerMobile = json['fleet_lawyer_mobile'];
    rentalCompanyAbn = json['rental_company_abn'];
    rentalCompanyName = json['rental_company_name'];
    termsNConditions = json['terms_n_conditions'];
    fleetVehicleOwner = json['fleet_vehicle_owner'];
    bpayCrn = json['bpay_crn'];
    ccToken = json['cc_token'];
    agreementCounter = json['agreement_counter'];
    balance = json['balance'];
    trackerBalance = json['tracker_balance'];
    rentalType = json['rental_type'];
    status = json['status'];
    goLive = json['go_live'];
    bankProcess = json['bank_process'];
    isDeleted = json['isDeleted'];
    inCollection = json['in_collection'];
    agentId = json['agent_id'];
    collectionReference = json['collection_reference'];
    defaultNotice = json['default_notice'];
    hasSetupRevenue = json['has_setup_revenue'];
    trackerType = json['tracker_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    outstanding = json['outstanding'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fleet_id'] = this.fleetId;
    data['fleet_name'] = this.fleetName;
    data['fleet_license_number'] = this.fleetLicenseNumber;
    data['fleet_license_state'] = this.fleetLicenseState;
    data['google_address'] = this.googleAddress;
    data['fleet_address'] = this.fleetAddress;
    data['fleet_street'] = this.fleetStreet;
    data['fleet_route'] = this.fleetRoute;
    data['fleet_city'] = this.fleetCity;
    data['fleet_state'] = this.fleetState;
    data['fleet_post'] = this.fleetPost;
    data['fleet_country'] = this.fleetCountry;
    data['fleet_ABN'] = this.fleetABN;
    data['fleet_customer_number'] = this.fleetCustomerNumber;
    data['fleet_phone_o'] = this.fleetPhoneO;
    data['fleet_phone_m'] = this.fleetPhoneM;
    data['fleet_phone_f'] = this.fleetPhoneF;
    data['fleet_logo'] = this.fleetLogo;
    data['fleet_emailid'] = this.fleetEmailid;
    data['fleet_website'] = this.fleetWebsite;
    data['fleet_owner_name'] = this.fleetOwnerName;
    data['fleet_owner_email'] = this.fleetOwnerEmail;
    data['fleet_owner_mobile'] = this.fleetOwnerMobile;
    data['fleet_manager_name'] = this.fleetManagerName;
    data['fleet_manager_email'] = this.fleetManagerEmail;
    data['fleet_manager_mobile'] = this.fleetManagerMobile;
    data['fleet_account_name'] = this.fleetAccountName;
    data['fleet_account_email'] = this.fleetAccountEmail;
    data['fleet_account_mobile'] = this.fleetAccountMobile;
    data['fleet_manager_signature'] = this.fleetManagerSignature;
    data['fleet_technical_name'] = this.fleetTechnicalName;
    data['fleet_technical_email'] = this.fleetTechnicalEmail;
    data['fleet_technical_mobile'] = this.fleetTechnicalMobile;
    data['fleet_lawyer_name'] = this.fleetLawyerName;
    data['fleet_lawyer_email'] = this.fleetLawyerEmail;
    data['fleet_lawyer_mobile'] = this.fleetLawyerMobile;
    data['rental_company_abn'] = this.rentalCompanyAbn;
    data['rental_company_name'] = this.rentalCompanyName;
    data['terms_n_conditions'] = this.termsNConditions;
    data['fleet_vehicle_owner'] = this.fleetVehicleOwner;
    data['bpay_crn'] = this.bpayCrn;
    data['cc_token'] = this.ccToken;
    data['agreement_counter'] = this.agreementCounter;
    data['balance'] = this.balance;
    data['tracker_balance'] = this.trackerBalance;
    data['rental_type'] = this.rentalType;
    data['status'] = this.status;
    data['go_live'] = this.goLive;
    data['bank_process'] = this.bankProcess;
    data['isDeleted'] = this.isDeleted;
    data['in_collection'] = this.inCollection;
    data['agent_id'] = this.agentId;
    data['collection_reference'] = this.collectionReference;
    data['default_notice'] = this.defaultNotice;
    data['has_setup_revenue'] = this.hasSetupRevenue;
    data['tracker_type'] = this.trackerType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['outstanding'] = this.outstanding;
    return data;
  }
}