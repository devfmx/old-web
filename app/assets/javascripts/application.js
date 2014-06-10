
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree ./vendor

var onLoaded = function() {
  if ( ! $.browser.mobile ) {
    new WOW().init();
  };

  var hero = $('.hero-intro'),
      heroH = hero.outerHeight(),
      bar = $('.topbar-wrap'),
      header = $('.main-header'),
      headerH = header.outerHeight(),
      home = $('.home');
  
  function setHeroHeight() {
    var winHeight = $(window).height();

    if ( heroH < winHeight ) {
      var h = winHeight - bar.outerHeight();
      hero.css('height', h);;
    } else {
      hero.height("auto");
    }
  }

  function barSticky() {
    var sTop = $(window).scrollTop(),
        off = bar.offset(),
        top = off.top,
        barH = bar.outerHeight();

    if ( sTop >= top - headerH ) {
      bar.addClass('active').find('.topbar').addClass('active').css('top', headerH);;
      header.addClass('active');
      bar.find('.spacer').css('height', barH);
    } else {
      bar.removeClass('active').find('.topbar').removeClass('active');
      header.removeClass('active');
      bar.find('.spacer').css('height', barH);
    }
  };

  if ( home.length ) {
    setHeroHeight();

    $(window).resize(function() {
      setHeroHeight();
    });

    $(window).scroll(function() {
      barSticky();
    });
  };
};

$(function(){
  onLoaded();
  $(document).on('page:load', onLoaded);
});