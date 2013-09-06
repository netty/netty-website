!function ($) {

$(function() {
  SyntaxHighlighter.defaults['gutter'] = false;
  SyntaxHighlighter.defaults['toolbar'] = false;
  SyntaxHighlighter.all();

  var $window = $(window)
  var $body   = $(document.body)
  var navHeight = $('.navbar').outerHeight(true) + 10

  $body.scrollspy({
    target: '.toc',
    offset: navHeight
  })

  $window.on('load', function () {
    $body.scrollspy('refresh')
  })

  // back to top
  setTimeout(function () {
    var $sideBar = $('.toc')

    $sideBar.affix({
      offset: {
        top: function () {
          var offsetTop      = $sideBar.offset().top
          var sideBarMargin  = parseInt($sideBar.children(0).css('margin-top'), 10)
          var navOuterHeight = $('.navbar-fixed-top').height()

          return (this.top = offsetTop - navOuterHeight - sideBarMargin - 20)
        },
      bottom: function () {
          return (this.bottom = $('#footer').outerHeight(true) + 64)
        }
      }
    })
  }, 50)
});

}(window.jQuery)

