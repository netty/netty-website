!function ($) {

$(function() {
  // Initialize syntax highlighter.
  SyntaxHighlighter.defaults['gutter'] = false;
  SyntaxHighlighter.defaults['toolbar'] = false;
  SyntaxHighlighter.all();

  var $window = $(window)
  var $body   = $(document.body)

  // Initialize scrollspy for navbar.
  var navHeight = $('.navbar').outerHeight(true) + 10

  $body.scrollspy({
    target: '.toc',
    offset: navHeight
  })

  $window.on('load', function () {
    $body.scrollspy('refresh')
  })

  // Back to top
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

  // Adjust the position and height of the embedded Twitter timeline dynamically.
  if ($('#twitter-timeline').length > 0) {
    setInterval(function() {
      var timeline = $('iframe#twitter-widget-0')
      if (timeline.length > 0) {
        var mainContent = $('#main-content')
        if (mainContent.length > 0) {
          var height = mainContent.height()
          if (timeline.height() != height) {
            timeline.height(height);
          }
        }
      }
    }, 100);
  }

  // Utility for visual form feedback (validation result)

  var disableFeedback = true;

  function updateFeedback(control, success) {
    var feedback = control.closest('div.has-feedback');
    if (feedback.length <= 0) {
      return;
    }

    if (success || disableFeedback) {
      feedback.removeClass('has-error');
    } else {
      feedback.removeClass('has-error');
      feedback.addClass('has-error');
    }
  }

  // Validation, sanitization, and submission of the donation form

  var donationForm = $('#donation-form');
  var donationTypeOnetime = $('#donation-type-onetime');
  var donationTypeRecurring = $('#donation-type-recurring');
  var donationFrequency = $('#donation-frequency');
  var donorName = $('#donor-name');
  var donationAmountUnit = $('#donation-amount-unit');
  var donationAmount = $('#donation-amount');
  var donationVisibility = $('#donation-visibility');
  var donateButton = $('#donate-button');

  if (donateButton.length > 0) {

    // Validate and sanitize the name of the donor.
    var updateDonorName = function() {
      var value = donorName.val().trim().replace(/\s+/g, ' ');
      if (value.length == 0) {
        updateFeedback(donorName, false);
      } else {
        updateFeedback(donorName, true);
        donorName.val(value);
      }
    };
    
    donorName.change(updateDonorName).blur(updateDonorName);
    updateDonorName();

    // Validate and sanitize the frequency of the donation.
    var updateDonationFrequency = function() {
      var isOnetime = donationTypeOnetime.is(':checked');
      if (isOnetime) {
        updateFeedback(donationFrequency, true);
        return;
      }

      var value = donationFrequency.val();
      var intValue;

      if (/^[0-9]+$/.test(value)) {
        intValue = parseInt(value.replace(/[^-.0-9]/g, ''));
      } else {
        intValue = -1;
      }

      if (isNaN(intValue) || intValue <= 0 || intValue > 12) {
        updateFeedback(donationFrequency, false);
        donationAmountUnit.text('...');
      } else {
        updateFeedback(donationFrequency, true);
        donationFrequency.val(intValue.toString());

        if (isOnetime) {
          donationAmountUnit.text('US $');
        } else if (intValue == 1) {
          donationAmountUnit.text('US $ / month');
        } else {
          donationAmountUnit.text('US $ / ' + intValue + ' months');
        }
      }
    };

    var updateDonationTypeVisibility = function() {
      if (donationTypeOnetime.is(':checked')) {
        donationFrequency.attr('disabled', true);
        donationAmountUnit.text('US $');
      } else {
        donationFrequency.removeAttr('disabled');
      }
      updateDonationFrequency();
    };

    donationTypeOnetime.change(updateDonationTypeVisibility);
    donationTypeRecurring.change(updateDonationTypeVisibility);
    donationFrequency.change(updateDonationFrequency).blur(updateDonationFrequency);

    updateDonationTypeVisibility();

    // Validate and sanitize the amount of the donation.
    var updateDonationAmount = function() {
      var value = donationAmount.val();
      var floatValue;
      if (/^[-+]?[0-9]*\.?[0-9]*$/.test(value)) {
        floatValue = parseFloat(value);
      } else {
        floatValue = -1;
      }

      if (isNaN(floatValue) || floatValue <= 0) {
        updateFeedback(donationAmount, false);
      } else {
        updateFeedback(donationAmount, true);
        donationAmount.val(new Intl.NumberFormat(
            'en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(floatValue));
      }
    };
    
    donationAmount.change(updateDonationAmount).blur(updateDonationAmount);
    updateDonationAmount();

    // Handle the submission of the donation.
    function submitOnetimeForm() {
      var target = $('#donation-form-onetime');
      target.find('input[name=item_name]').val('One-time $' + donationAmount.val() + ' USD donation');
      target.find('input[name=amount]').val(donationAmount.val());
      target.find('input[name=os0]').val(donorName.val());
      target.find('input[name=os1]').val(donationVisibility.val());
      target.submit();
    }

    function submitRecurringForm() {
      var target = $('#donation-form-recurring');
      var itemName;
      if (donationFrequency.val() == '1') {
        itemName = 'Recurring $' + donationAmount.val() + ' USD donation for each month';
      } else {
        itemName = 'Recurring $' + donationAmount.val() + ' USD donation for each ' +
                   donationFrequency.val() + ' months';
      }

      target.find('input[name=item_name]').val(itemName);
      target.find('input[name=a3]').val(donationAmount.val());
      target.find('input[name=p3]').val(donationFrequency.val());
      target.find('input[name=os0]').val(donorName.val());
      target.find('input[name=os1]').val(donationVisibility.val());
      target.submit();
    }

    donationForm.submit(function(e) {
      disableFeedback = false;
      updateDonorName();
      updateDonationTypeVisibility();
      updateDonationAmount();

      if (donationForm.find('.has-error').length == 0) {
        var isOnetime = donationTypeOnetime.is(':checked');
        if (isOnetime) {
          submitOnetimeForm();
        } else {
          submitRecurringForm();
        }
      }

      return false;
    });
  }

  disableFeedback = false;
});

}(window.jQuery)

