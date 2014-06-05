define([ "jquery", "autocomplete" ], function($, Autocomplete) {

  "use strict";

  function NavSearch() {

    var el = ".js-primary-search",
        $el = $(el);

    // switch search icon on click
    $el.on("focus", function() {
      $(".js-search-icon").addClass("active-search");
    }).on("blur", function() {
      $(".js-search-icon").removeClass("active-search");
    });

    new Autocomplete({
      el: el,
      threshold: 0,
      limit: 10,
      template: {
        elementWrapper: "<div class='js-autocomplete primary-search-autocomplete'></div>",
        resultsWrapper: "<div class='autocomplete'></div>",
        resultsContainer: "<div class='autocomplete__results icon--tapered-arrow-up--after icon--white--after'></div>",
        resultsItemHighlightClass: "autocomplete__results__item--highlight",
        resultsItem: "<a class='autocomplete__results__item icon--{{type}}--before' href='{{slug}}'>{{name}}</a>",
        searchTermHighlightClass: "autocomplete__search-term--highlight",
        hiddenClass: "is-hidden"

      },
      fetch: function(searchTerm, cb) {
        $.ajax({
          // url: "//localhost:9000/search.json?q=" + searchTerm,
          url: "//www.lonelyplanet.com/search.json?q=" + searchTerm,
          dataType: "json",
          success: function(data) {
            cb(data);
            $el.closest(".js-autocomplete").find(".autocomplete__results").append("<a class='btn btn--small backup-button' href='http://www.lonelyplanet.com/search?q=" + searchTerm + "'>See all results</a>");
          }
        });
      },
      onItem: this.onItem
    });
  }

  NavSearch.prototype.onItem = function(el) {
    window.location = $(el).attr("href");
  };

  return NavSearch;

});