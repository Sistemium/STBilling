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
