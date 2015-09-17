#= require shared_namespace
#= require_tree ./utils
#= require_tree ./helpers
#= require_tree ./core_extentions
#= require      ./vendor_modified/jquery.simple-text-rotator
#= require      ./vendor_modified/jquery.unveil-1.3.0
#= require_tree ./components
#= require_self

CStone.Shared.logger = new CStone.Shared.Utils.Logger('production')
# Off by default. Use the following to activate a single browser:
# CStone.Shared.logger.verbose_mode(true)

