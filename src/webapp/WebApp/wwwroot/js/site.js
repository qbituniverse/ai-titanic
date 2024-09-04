function testPing()
{
    $.ajax({
        async: true,
        type: "GET",
        url: "/Home/GetPing",
        success: function (ping) {
            if (ping !== "Ok") {
                alert ("Looks like communication with AI APIs is down. Please try again later...");
                console.error("Ping returned not Ok");
            }
        },
        error: function (err) {
            alert ("Looks like communication with AI APIs is down. Please try again later...");
            console.error(err);
        }
    });
}

function resolveAlgorithmType(type) {
    switch (type) {
        case 1: return "Lazy Learning: Nearest Neighbours";
        case 2: return "Probabilistic Learning: Naive Bayes";
        case 3: return "Probabilistic Learning Logistic: Regression";
        case 4: return "Decision Tree: C50";
        case 5: return "Decision Tree: RPART";
        case 6: return "Decision Tree: CTREE";
        case 7: return "Rule Learner: 1R";
        case 8: return "Rule Learner: RIPPER";
        case 9: return "Black Box: Artificial Neural Networks: Neuralnet";
        case 10: return "Black Box: Artificial Neural Networks: Nnet";
        case 11: return "Black Box: Support Vector Machines: Ksvm";
        case 12: return "Black Box: Support Vector Machines: Svm";
    }
    return "";
}

function formatPercent(value) {
    return value + "%";
}