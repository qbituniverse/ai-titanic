function loadAlgorithms() {
    $(document).ready(function() {
        testPing();
        getStats(printStats);
    });
}

function getStats(callback)
{
    $.ajax({
        async: true,
        type: "GET",
        url: "/Algorithms/GetStats",
        success: function (stats) {
            callback(stats);
        },
        error: function (err) {
            alert ("Looks like communication with AI APIs is down. Please try again later...");
            console.error(err);
        }
    });
}

function printStats(stats) {
    $.each(stats, function(i, s) {
        var table = "<table class='table table-hover'>" +
        "<tr><td class='col-sm-1'>Sensitivity</td><td class='col-sm-1'>" + formatPercent(s.summary[0].sensitivity) + "</td></tr>" +
        "<tr><td class='col-sm-1'>Specificity</td><td class='col-sm-1'>" + formatPercent(s.summary[0].specificity) + "</td></tr>" +
        "<tr><td class='col-sm-1'>Precision</td><td class='col-sm-1'>" + formatPercent(s.summary[0].precision) + "</td></tr>" +
        "<tr><td class='col-sm-1'>Recall</td><td class='col-sm-1'>" + formatPercent(s.summary[0].recall) + "</td></tr>" +
        "<tr><td class='col-sm-1'>F1</td><td class='col-sm-1'>" + s.summary[0].f1 + "</td></tr>" +
        "<tr><td class='col-sm-1'>Kappa - Weighted</td><td class='col-sm-1'>" + s.summary[0].kappaWeighted + "</td></tr>" +
        "<tr><td class='col-sm-1'>Kappa - Unweighted</td><td class='col-sm-1'>" + s.summary[0].kappaUnweighted + "</td></tr>" +
        "<tr><td class='col-sm-1'>Balanced Accuracy</td><td class='col-sm-1'>" + formatPercent(s.summary[0].balancedAccuracy) + "</td></tr>" +
        "<tr><td class='col-sm-1'>Accuracy</td><td class='col-sm-1'>" + formatPercent(s.summary[0].accuracy) + "</td></tr>" +
        "<tr><td class='col-sm-1'>Error Rate</td><td class='col-sm-1'>" + formatPercent(s.summary[0].errorRate) + "</td></tr>";
        var divHeading = "<div class='panel-heading'><h4>" + resolveAlgorithmType(s.type[0]) + "</h4></div>";
        var divBody = "<div class='panel-body'>" + table + "</div>";
        var div = "<div class='panel panel-default'>" + divHeading + divBody + "</div>";
        $("#algorithmsList").append(div);
    });
}