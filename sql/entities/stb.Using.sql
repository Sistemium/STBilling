ch.defineEntity 'User',
    @properties = 'name:price',
    @roles = ''
;

ch.createTable @entity = 'User',
    @owner = 'stb', @isTemporary = 0, @forseDrop = 0
;