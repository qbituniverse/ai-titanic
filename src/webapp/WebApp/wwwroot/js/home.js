function loadHome() {
    $(document).ready(function() {
        testPing();
        clearResults();

        $("#inputSex").slider({
            value: 1,
            ticks: [1, 2],
            ticks_labels: ["Male", "Female"],
            ticks_snap_bounds: 1,
            tooltip: "hide"
        });

        $("#inputAge").slider({
            value: 30,
            tooltip: "always",
            tooltip_position:"bottom"
        });

        $("#inputPclass").slider({
            value: 1,
            ticks: [1, 2, 3],
            ticks_labels: ["1st", "2nd", "3rd"],
            ticks_snap_bounds: 1,
            tooltip: "hide"
        });

        $("#inputFare").slider({
            precision: 2,
            value: 100,
            tooltip: "always",
            tooltip_position:"bottom"
        });

        $("#inputSibsp").slider({
            value: 0,
            ticks: [0, 1, 2, 3, 4, 5, 6, 7, 8],
            ticks_labels: ["0", "1", "2", "3", "4", "5", "6", "7", "8"],
            ticks_snap_bounds: 1,
            tooltip: "hide"
        });

        $("#inputParch").slider({
            value: 0,
            ticks: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
            ticks_labels: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"],
            ticks_snap_bounds: 1,
            tooltip: "hide"
        });

        $("#btnPredict").click(function () {
            clearResults();
            showPredictLoader();
            var predictionRequest = {
                "sex": ($("#inputSex").val() === 1 ? "male" : "female"),
                "age": $("#inputAge").val(),
                "pclass": $("#inputPclass").val(),
                "fare": $("#inputFare").val(),
                "sibsp": $("#inputSibsp").val(),
                "parch": $("#inputParch").val()
            };
            getPrediction(predictionRequest, printPredictions);
        });

        $("#btnClear").click(function () { 
            location.reload();
        });
    });
}

function getPrediction(predictionRequest, callback)
{
    $.ajax({
        async: true,
        type: "POST",
        url: "/Home/GetPrediction",
        data: { "predictionRequest": predictionRequest },
        success: function (prediction) {
            callback(prediction);
            showPredictResults();
        },
        error: function (err) {
            alert ("Looks like communication with AI APIs is down. Please try again later...");
            console.error(err);
        }
    });
}

function printPredictions(prediction) {
    var tableSurvived = "<table class='table table-hover'>" +
    setPredictionColor(prediction.survived.result[0]) +
    "<td class='col-sm-1'>Survived</td><td class='capitalise col-sm-1'>" + prediction.survived.result + "</td></tr>" +
    "<tr><td class='col-sm-1'>Confidence</td><td class='col-sm-1'>" + formatPercent(prediction.survived.confidence) + "</td></tr>";
    var divHeadingSurvived = "<div class='panel-heading'><h4>Final Prediction of Survival</h4></div>";
    var divBodySurvived = "<div class='panel-body'>" + tableSurvived + "</div>";
    var divSurvived = "<div class='panel panel-default'>" + divHeadingSurvived + divBodySurvived + "</div>";
    $("#predictionSurvived").append(divSurvived);

    var tableConfidence = "<table class='table table-hover'>" +
    "<tr><td class='col-sm-1'>Survived</td><td class='col-sm-1'>" + formatPercent(prediction.confidence.survived) + "</td></tr>" +
    "<tr><td class='col-sm-1'>Perished</td><td class='col-sm-1'>" + formatPercent(prediction.confidence.perished) + "</td></tr>";
    var divHeadingConfidence = "<div class='panel-heading'><h4>Final Prediction Confidence</h4></div>";
    var divBodyConfidence = "<div class='panel-body'>" + tableConfidence + "</div>";
    var divConfidence = "<div class='panel panel-default'>" + divHeadingConfidence + divBodyConfidence + "</div>";
    $("#predictionConfidence").append(divConfidence);

    $.each(prediction.models, function(i, m) {
        var tableModels = "<table class='table table-hover'>" +
        setPredictionColor(m[0].prediction) +
        "<td class='col-sm-1'>Survived</td><td class='capitalise col-sm-1'>" + m[0].prediction + "</td></tr>" +
        "<tr><td class='col-sm-1'>Final Probability</td><td class='col-sm-1'>" + formatPercent(m[0]["probabilityFinal"]) + "</td></tr>" +
        "<tr><td class='col-sm-1'>Survived Probability</td><td class='col-sm-1'>" + formatPercent(m[0]["probabilitySurvived"]) + "</td></tr>" +
        "<tr><td class='col-sm-1'>Perished Probability</td><td class='col-sm-1'>" + formatPercent(m[0]["probabilityPerished"]) + "</td></tr>" +
        "<tr><td class='col-sm-1'>Sensitivity</td><td class='col-sm-1'>" + m[0].sensitivity + "</td></tr>" +
        "<tr><td class='col-sm-1'>Specificity</td><td class='col-sm-1'>" + m[0].specificity + "</td></tr>" +
        "<tr><td class='col-sm-1'>F1</td><td class='col-sm-1'>" + m[0].f1 + "</td></tr>" +
        "<tr><td class='col-sm-1'>Kappa</td><td class='col-sm-1'>" + m[0].kappa + "</td></tr>";
        var divHeadingModels = "<div class='panel-heading'><h4>" + resolveAlgorithmType(m[0].type) + "</h4></div>";
        var divBodyModels = "<div class='panel-body'>" + tableModels + "</div>";
        var divModels = "<div class='panel panel-default'>" + divHeadingModels + divBodyModels + "</div>";
        $("#predictionModels").append(divModels);
    });
}

function clearResults() {
    $("#predictionSurvived").html("");
    $("#predictionConfidence").html("");
    $("#predictionModels").html("");
}

function showPredictLoader() {
    $("#predict-waiter").hide();
    $("#predict-results").hide();
    $("#predict-loader").slideDown(200);
}

function showPredictResults() {
    $("#predict-loader").hide();
    $("#predict-waiter").hide();
    $("#btnClear").html("Start Again");
    $("#predict-results").slideDown(200);
}

function setPredictionColor(result) {
    if (result.toLowerCase() === "yes") {
        return "<tr class='green'>";
    } else { return "<tr class='red'>"; }
}