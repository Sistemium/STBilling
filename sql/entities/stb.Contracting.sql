ch.defineEntity 'Contract',
    @properties = 'ndoc:dateB:dateE',
    @roles = 'Org'
;

ch.defineEntity 'Service',
    @properties = 'name',
    @roles = ''
;

ch.defineEntity 'Period',
    @properties = 'dateB:dateE',
    @roles = ''
;

ch.defineEntity 'Tariff',
    @properties = 'price',
    @roles = 'Contract:Service'
;

ch.defineEntity 'Accrual',
    @properties = 'date:volume:description:href:acceptanceDate',
    @roles = 'Contract:Service'
;

ch.defineEntity 'LegalEntity',
    @properties = 'name:legalName',
    @roles = 'Org'
;

ch.defineEntity 'LegalContract',
    @properties = 'ndoc:dateB:dateE',
    @roles = 'LegalEntity'
;

ch.defineEntity 'ProgramLicense',
    @properties = 'name:term:dateB:dateE',
    @roles = 'LegalContract'
;


ch.createTable @entity = 'LegalEntity',
    @owner = 'stb', @isTemporary = 0, @forseDrop = 0
;

ch.createTable @entity = 'LegalContract',
    @owner = 'stb', @isTemporary = 0, @forseDrop = 0
;

ch.createTable @entity = 'ProgramLicense',
    @owner = 'stb', @isTemporary = 0, @forseDrop = 0
;

ch.createTable @entity = 'Contract',
    @owner = 'stb', @isTemporary = 0, @forseDrop = 0
;

ch.createTable @entity = 'Service',
    @owner = 'stb', @isTemporary = 0, @forseDrop = 0
;

ch.createTable @entity = 'Period',
    @owner = 'stb', @isTemporary = 0, @forseDrop = 0
;

ch.createTable @entity = 'Tariff',
    @owner = 'stb', @isTemporary = 0, @forseDrop = 0
;

ch.createTable @entity = 'Accrual',
    @owner = 'stb', @isTemporary = 0, @forseDrop = 0
;
