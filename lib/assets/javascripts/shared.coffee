#= require shared_namespace
#= require_tree ./utils
#= require_tree ./helpers
#= require_tree ./core_extentions
#= require_tree ./vendor_modified
#= require_tree ./components
#= require_self

CStone.Shared.logger = new CStone.Shared.Utils.Logger('production')
# Off by default. Use the following to activate a single browser:
# CStone.Shared.logger.verbose_mode(true)
 