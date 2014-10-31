# ====================================================
# =                      Model                       =
# ====================================================
BackboneFactory.define 'source', CStone.Community.Search.Models.AbstractSource, ->
  name:   'ministry'
  local:  [{ payload: 'doggy', id:21 }, { payload: 'pig', id:22 }, { payload: 'moose', id:23 }, { payload: "men's ministry", id:25 }]
  
  # session: Factory.session(sources:'dummy')
  # title:       'Your Title Here'
  # description: 'string, function, or another Factory'
  # size:         _(['Tall', 'Grande', 'Venti', 'Trenta']).shuffle()[0]
  # section:      Factory.section()

# ====================================================
# =                   Collection                     =
# ====================================================
_(window.Factory ||= {}).extend({
  sources:   (overrides)->   new CStone.Community.Search.Collections.Sources  _({
    models: _([1,2,3]).map -> BackboneFactory.create('source', ->)
    }).extend( overrides )

})


# ====================================================
# =               Complex Factories                 =
# ====================================================
refreshFactoryInterface()
Factory.sources_from_session = (overrides)-> Factory.session(sources: Factory.sources(overrides).models).get('sources')
Factory.source_from_session  = (overrides)-> Factory.session(sources: Factory.sources(overrides).models).get('sources').first()

# section_w_section_materials: (overrides)-> Factory.section( _( section_materials: Factory.section_materials().models ).extend(overrides) )
# distributor_w_offers:        (overrides)-> Factory.distributor( _(offers: Factory.offers().models ).extend(overrides))