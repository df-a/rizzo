require([ "jquery", "lib/analytics/analytics" ], function($, Analytics) {

  "use strict";

  var omniCode = "LP highlights Insurance",
      analytics = new Analytics();

  analytics.trackView();

  // Set up Omniture event handlers

  var windowUnloadedFromSubmitClick = false;

  // If the user clicks anywhere else on the page, reset the click tracker
  $(document).on("click", function() {
    windowUnloadedFromSubmitClick = false;
  });

  // When the user clicks on the submit button, track that it's what
  // is causing the onbeforeunload event to fire (below)
  $(document).on("click", "button.cta-button-primary", function(e) {
    windowUnloadedFromSubmitClick = true;
    e.stopPropagation();
  });

  // Before redirection (which the WN widget does, it's not a form submit)
  // if the user clicked on the submit button, track click with Omniture
  window.onbeforeunload = function() {
    if (windowUnloadedFromSubmitClick) {
      window.s.events = "event42";
      window.s.t();
    }
  };

  $(".nomads-links a").on("click", function() {
    analytics.track({ events: "event42" });
  });

  $(".article--row a").on("click", function() {
    window.s.linkTrackVars = "eVar54";
    window.s.eVar54 = omniCode;
    window.s.events = "event45";
    window.s.tl(this, "o", omniCode);
  });
});
