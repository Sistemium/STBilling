ch.defineEntity 'User',
    @properties = 'name:price',
    @roles = ''
;

ch.createTable @entity = 'User',
    @owner = 'stb', @isTemporary = 0, @forseDrop = 0
;

ch.defineEntity 'Agent',
    @properties = 'name:username',
    @roles = 'LegalEntity'
;

ch.createTable @entity = 'Agent',
    @owner = 'stb', @isTemporary = 0, @forseDrop = 0
;