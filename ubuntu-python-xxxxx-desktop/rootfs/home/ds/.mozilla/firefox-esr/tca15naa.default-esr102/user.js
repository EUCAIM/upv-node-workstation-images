
// Disable sponsored sites in new tab page
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
// Hide other sites like Facebook, Amazon, Youtube...
user_pref("browser.newtabpage.blocked", "{\"4gPpjkxgZzXPVtuEoAL9Ig==\":1,\"26UbzFJ7qT9/4DhodHKA1Q==\":1,\"K00ILysCaEq8+bEqV/3nuw==\":1,\"T9nJot5PurhJSy8n038xGA==\":1,\"gLv0ja2RYVgxKdp0I5qwvA==\":1}");
// Add the dataset-service site
user_pref("browser.newtabpage.pinned", "[{\"url\":\"https://eucaim-node.i3m.upv.es/dataset-service\"}]");

// Don't ask for saving passwords
user_pref("signon.rememberSignons", false);

// Don't participate in studies, upload telemetry, healtreports, etc.
user_pref("app.shield.optoutstudies.enabled", false);
user_pref("toolkit.telemetry.reportingpolicy.firstRun", false);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("datareporting.healthreport.service.enabled", false);
user_pref("datareporting.healthreport.service.firsRun", false);
// Don't show the tip to configure telemetry
user_pref("datareporting.policy.dataSubmissionPolicyAcceptedVersion", 2);
user_pref("datareporting.policy.dataSubmissionPolicyNotifiedTime", "1533619817422");

// Don't show welcome page nor new version release notes
user_pref("startup.homepage_welcome_url", "");
user_pref("browser.startup.homepage_override.mstone", "ignore");

// Disable spell check
user_pref("layout.spellcheckDefault", 0);
