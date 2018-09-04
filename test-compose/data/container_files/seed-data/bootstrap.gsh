gs = GrouperSession.startRootSession()

addStem("","app", "enterprise applications access control policy")
addStem("","basis", "groups used exclusively by the IAM team to build reference groups")
addStem("","bundle", "sets of reference groups used in policy for many services")
addStem("","org", "delegated authority, ad-hoc groups, org owned apps or reference groups")
addStem("","ref", "reference groups (i.e. institutional meaningful cohorts)")
addStem("","test", "test folder for system verification")

addMember("etc:sysadmingroup","banderson");
