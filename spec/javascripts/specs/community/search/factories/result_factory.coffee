# ====================================================
# =                      Model                       =
# ====================================================
BackboneFactory.define 'result', Community.Search.Models.Result, ->
  # title:       'Your Title Here'
  # description: 'string, function, or another Factory'
  # size:         _(['Tall', 'Grande', 'Venti', 'Trenta']).shuffle()[0]
  # section:      Factory.section()





# ====================================================
# =                   Collection                     =
# ====================================================
_(window.Factory ||= {}).extend({
  results:   (overrides)->   new Community.Search.Collections.Results  _({
    models: _([1,2,3]).map -> BackboneFactory.create('result', ->)
    }).extend( overrides )

})


# ====================================================
# =               Complex Factories                 =
# ====================================================
refreshFactoryInterface()
# section_w_section_materials: (overrides)-> Factory.section( _( section_materials: Factory.section_materials().models ).extend(overrides) )
# distributor_w_offers:        (overrides)-> Factory.distributor( _(offers: Factory.offers().models ).extend(overrides))