'use strict'

angular.module('app.chart.ctrls', [])

.controller('chartCtrl', [
    '$scope'
    ($scope) ->

        $scope.easypiechartsm1 = 
            percent: 63
            options:
                animate:
                    duration: 1000
                    enabled: false
                barColor: $scope.color.success
                lineCap: 'round'
                size: 120
                lineWidth: 5
        $scope.easypiechartsm2 = 
            percent: 35
            options:
                animate:
                    duration: 1000
                    enabled: false
                barColor: $scope.color.info
                lineCap: 'round'
                size: 120
                lineWidth: 5
        $scope.easypiechartsm3 = 
            percent: 75
            options:
                animate:
                    duration: 1000
                    enabled: false
                barColor: $scope.color.warning
                lineCap: 'round'
                size: 120
                lineWidth: 5
        $scope.easypiechartsm4 = 
            percent: 66
            options:
                animate:
                    duration: 1000
                    enabled: false
                barColor: $scope.color.danger
                lineCap: 'round'
                size: 120
                lineWidth: 5

        $scope.easypiechart = 
            percent: 65
            options:
                animate:
                    duration: 1000
                    enabled: true
                barColor: $scope.color.primary
                lineCap: 'round'
                size: 180
                lineWidth: 5

        $scope.easypiechart2 = 
            percent: 35
            options:
                animate:
                    duration: 1000
                    enabled: true
                barColor: $scope.color.success
                lineCap: 'round'
                size: 180
                lineWidth: 10

        $scope.easypiechart3 = 
            percent: 68
            options:
                animate:
                    duration: 1000
                    enabled: true
                barColor: $scope.color.info
                lineCap: 'square'
                size: 180
                lineWidth: 20
                scaleLength: 0


        # Note: the online documentation of Gauge is outdated, thanks to https://github.com/bernii/gauge.js/issues/47
        # Note2: it's not responsive
        $scope.gaugeChart1 =
            data:
                maxValue: 3000
                animationSpeed: 40
                val: 1375
            options:
                lines: 12
                angle: 0
                lineWidth: 0.47
                pointer:
                    length: 0.6
                    strokeWidth: 0.03
                    color: '#000000'
                limitMax: 'false'
                # colorStart: '#A3C86D'
                # colorStop: '#A3C86D',
                strokeColor: '#E0E0E0'
                generateGradient: true
                percentColors: [
                    [0.0, $scope.color.success]
                    [1.0, $scope.color.success]
                ]

        $scope.gaugeChart2 =
            data:
                maxValue: 3000
                animationSpeed: 45
                val: 1200
            options:
                lines: 12
                angle: 0
                lineWidth: 0.47
                pointer:
                    length: 0.6
                    strokeWidth: 0.03
                    color: '#464646'
                limitMax: 'true'
                colorStart: '#7ACBEE'
                colorStop: '#7ACBEE',
                strokeColor: '#F1F1F1'
                generateGradient: true
                percentColors: [
                    [0.0, $scope.color.info]
                    [1.0, $scope.color.info]
                ]

        $scope.gaugeChart3 =
            data:
                maxValue: 3000
                animationSpeed: 50
                val: 1100
            options:
                lines: 12
                angle: 0
                lineWidth: 0.47
                pointer:
                    length: 0.6
                    strokeWidth: 0.03
                    color: '#464646'
                limitMax: 'true'
                colorStart: '#FF7857'
                colorStop: '#FF7857',
                strokeColor: '#F1F1F1'
                generateGradient: true
                percentColors: [
                    [0.0, $scope.color.danger]
                    [1.0, $scope.color.danger]
                ] 

])
.controller('chartjsCtrl', [
    '$scope'
    ($scope) ->

        randomScalingFactor = ->
            return Math.round(Math.random()*100)

        $scope.lineChartType = 'line'
        $scope.lineChartData = {
            labels : ["January","February","March","April","May","June","July"]
            datasets : [
                label: "My First dataset"
                fillColor : "rgba(220,220,220,0.2)"
                strokeColor : "rgba(220,220,220,1)"
                pointColor : "rgba(220,220,220,1)"
                pointStrokeColor : "#fff"
                pointHighlightFill : "#fff"
                pointHighlightStroke : "rgba(220,220,220,1)"
                data : [65, 59, 90, 81, 56, 55, 40]
            ,
                label: "My Second dataset"
                fillColor : one.color($scope.color.primary).alpha(.2).cssa()
                strokeColor : $scope.color.primary
                pointColor : $scope.color.primary
                pointStrokeColor : "#fff"
                pointHighlightFill : "#fff"
                pointHighlightStroke : $scope.color.primary
                data : [28, 48, 40, 19, 96, 27, 100]
            ]
        }
        $scope.lineChartOpts =
            responsive: true


        $scope.barChartType = 'bar'
        $scope.barChartData = {
            labels : ["January","February","March","April","May","June","July"]
            datasets : [
                fillColor : "rgba(220,220,220,0.5)"
                strokeColor : "rgba(220,220,220,0.8)"
                highlightFill: "rgba(220,220,220,0.5)"
                highlightStroke: "rgba(220,220,220,1)"
                data : [65, 59, 90, 81, 56, 55, 40]
            ,
                fillColor : one.color($scope.color.primary).alpha(.5).cssa()
                strokeColor : one.color($scope.color.primary).alpha(.8).cssa()
                highlightFill : one.color($scope.color.primary).alpha(.7).cssa()
                highlightStroke : $scope.color.primary
                data : [28, 48, 40, 19, 96, 27, 100]
            ]
        }
        $scope.barChartOpts =
            responsive: true


        $scope.radarChartType = 'radar'
        $scope.radarChartData = {
            labels: ["Eating", "Drinking", "Sleeping", "Designing", "Coding", "Cycling", "Running"]
            datasets: [
                label: "My First dataset"
                fillColor: "rgba(220,220,220,0.2)"
                strokeColor: "rgba(220,220,220,1)"
                pointColor: "rgba(220,220,220,1)"
                pointStrokeColor: "#fff"
                pointHighlightFill: "#fff"
                pointHighlightStroke: "rgba(220,220,220,1)"
                data: [65,59,90,81,56,55,40]
            ,
                label: "My Second dataset"
                fillColor: one.color($scope.color.primary).alpha(.5).cssa()
                strokeColor: $scope.color.primary
                pointColor: $scope.color.primary
                pointStrokeColor: "#fff"
                pointHighlightFill: "#fff"
                pointHighlightStroke: $scope.color.primary
                data: [28,48,40,19,96,27,100]
            ]            
        }
        $scope.radarChartOpts =
            responsive: true


        $scope.polarAreaChartType = 'polarArea'
        $scope.polarAreaChartData = [
            value: 300
            color: $scope.color.danger
            highlight: one.color($scope.color.danger).alpha(.9).cssa()
            label: "Red"
        ,
            value: 50
            color: $scope.color.success
            highlight: one.color($scope.color.success).alpha(.9).cssa()
            label: "Green"
        ,
            value: 100
            color: $scope.color.warning
            highlight: one.color($scope.color.warning).alpha(.9).cssa()
            label: "Yellow"
        ,
            value: 40
            color: "#949FB1"
            highlight: "#A8B3C5"
            label: "Grey"
        ,
            value: 120
            color: "#4D5360"
            highlight: "#616774"
            label: "Dark Grey"
        ]
        $scope.polarAreaChartOpts =
            responsive: true


        $scope.pieChartType = 'pie'
        $scope.pieChartData = [
            value: 300,
            color: $scope.color.danger
            highlight: one.color($scope.color.danger).alpha(.9).cssa()
            label: "Red"
        ,
            value: 50,
            color: $scope.color.success
            highlight: one.color($scope.color.success).alpha(.9).cssa()
            label: "Green"
        ,
            value: 100,
            color: $scope.color.warning
            highlight: one.color($scope.color.warning).alpha(.9).cssa()
            label: "Yellow"
        ,
            value: 40,
            color: "#949FB1"
            highlight: "#A8B3C5"
            label: "Grey"
        ,
            value: 120,
            color: "#4D5360"
            highlight: "#616774"
            label: "Dark Grey"
        ]
        $scope.pieChartOpts =
            responsive: true
            animationEasing: "easeOutQuart"
            animateRotate : false
            animateScale : true
            legendTemplate : "<ul class=\"<%=name.toLowerCase()%>-legend\"><% for (var i=0; i<segments.length; i++){%><li><span style=\"background-color:<%=segments[i].fillColor%>\"></span><%if(segments[i].label){%><%=segments[i].label%><%}%></li><%}%></ul>"


        $scope.donutChartType = 'doughnut'
        $scope.donutChartData = [
            value: 300,
            color: $scope.color.danger
            highlight: one.color($scope.color.danger).alpha(.9).cssa()
            label: "Red"
        ,
            value: 50,
            color: $scope.color.success
            highlight: one.color($scope.color.success).alpha(.9).cssa()
            label: "Green"
        ,
            value: 100,
            color: $scope.color.warning
            highlight: one.color($scope.color.warning).alpha(.9).cssa()
            label: "Yellow"
        ,
            value: 40,
            color: "#949FB1"
            highlight: "#A8B3C5"
            label: "Grey"
        ,
            value: 120,
            color: "#4D5360"
            highlight: "#616774"
            label: "Dark Grey"
        ]
        $scope.donutChartOpts =
            responsive: true
            legendTemplate : "<ul class=\"<%=name.toLowerCase()%>-legend\"><% for (var i=0; i<segments.length; i++){%><li><span style=\"background-color:<%=segments[i].fillColor%>\"></span><%if(segments[i].label){%><%=segments[i].label%><%}%></li><%}%></ul>"
])
.controller('flotChartCtrl', [
    '$scope'
    ($scope) ->

        # Line Chart
        lineChart1 = {}
        lineChart1.data1 = [[1,15],[2,20],[3,14],[4,10],[5,10],[6,20],[7,28],[8,26],[9,22]]
        $scope.line1 = {}
        $scope.line1.data = [
            data: lineChart1.data1
            label: 'Trend'
        ]
        $scope.line1.options = {
            series:
                lines:
                    show: true
                    fill: true
                    fillColor: { colors: [ { opacity: 0 }, { opacity: 0.3 } ] }
                points:
                    show: true
                    lineWidth: 2
                    fill: true
                    fillColor: "#ffffff"
                    symbol: "circle"
                    radius: 5
            colors: [$scope.color.primary, $scope.color.infoAlt]
            tooltip: true
            tooltipOpts:
                defaultTheme: false
            grid:
                hoverable: true
                clickable: true
                tickColor: "#f9f9f9"
                borderWidth: 1
                borderColor: "#eeeeee"
            xaxis:
                 ticks: [[1,'Jan.'],[2,'Feb.'],[3,'Mar.'],[4,'Apr.'],[5,'May'],[6,'June'],[7,'July'],[8,'Aug.'],[9,'Sept.'],[10,'Oct.'],[11,'Nov.'],[12,'Dec.'],]
        }

        # Area Chart
        areaChart = {}
        areaChart.data1 = [[2007,15],[2008,20],[2009,10],[2010,5],[2011,5],[2012,20],[2013,28]]
        areaChart.data2 = [[2007,15],[2008,16],[2009,22],[2010,14],[2011,12],[2012,19],[2013,22]]
        $scope.area = {}
        $scope.area.data = [
            data: areaChart.data1
            label: "Value A"
            lines:
                fill: true
        ,
            data: areaChart.data2
            label: "Value B"
            points:
                show: true
            yaxis: 2
        ]
        $scope.area.options = {
            series:
                lines:
                    show: true
                    fill: false
                points:
                    show: true
                    lineWidth: 2
                    fill: true
                    fillColor: "#ffffff"
                    symbol: "circle"
                    radius: 5
                shadowSize: 0
            grid:
                hoverable: true
                clickable: true
                tickColor: "#f9f9f9"
                borderWidth: 1
                borderColor: "#eeeeee"
            colors: [$scope.color.success, $scope.color.danger]
            tooltip: true
            tooltipOpts:
                defaultTheme: false
            xaxis:
                mode: "time"
            yaxes: [{
                # First y axis
            }, {
                # Second y axis
                position: "right"
            }]
        }


        # flot.curvedlines needed to draw curved lines
        # it's actually draw 2 chart for 1, one is curved line only, and the other is points only
        sampledata1 = [[1,65], [2,59], [3,90], [4,81], [5,56], [6,55], [7,40]]
        sampledata2 = [[1,28], [2,48], [3,40], [4,19], [5,96], [6,27], [7,10]]
        $scope.area1 = {}
        $scope.area1.data = [
            data: sampledata1
            curvedLines:
                apply: true
            lines:
                show: true
                fill: true
                fillColor: { colors: [ { opacity: 0.2 }, { opacity: 0.2 } ] }
        ,
            data: sampledata1
            label: "C"
            points:
                show: true
        ,
            data: sampledata2
            curvedLines:
                apply: true
            lines:
                show: true
                fill: true
                fillColor: { colors: [ { opacity: 0.2 }, { opacity: 0.2 } ] }
        ,
            data: sampledata2
            label: "D"
            points:
                show: true
        ]
        $scope.area1.options = {
            series:
                curvedLines:
                    active: true
                points:
                    lineWidth: 2
                    fill: true
                    fillColor: "#ffffff"
                    symbol: "circle"
                    radius: 4
            grid:
                hoverable: true
                clickable: true
                tickColor: "#f9f9f9"
                borderWidth: 1
                borderColor: "#eeeeee"
            tooltip: true
            tooltipOpts:
                defaultTheme: false
            colors: [$scope.color.gray, $scope.color.gray, $scope.color.primary, $scope.color.primary]
        }

        # Stacked bar chart
        barChart = {} 
        barChart.data1 = [[2008,20],[2009,10],[2010,5],[2011,5],[2012,20],[2013,28]]
        barChart.data2 = [[2008,16],[2009,22],[2010,14],[2011,12],[2012,19],[2013,22]]
        barChart.data3 = [[2008,12],[2009,30],[2010,20],[2011,19],[2012,13],[2013,20]]
        $scope.barChart = {}
        $scope.barChart.data = [
                label: "Value A"
                data: barChart.data1
            ,
                label: "Value B"
                data: barChart.data2
            ,
                label: "Value C"
                data: barChart.data3
        ]
        $scope.barChart.options =
            series:
                stack: true
                bars:
                    show: true
                    fill: 1
                    barWidth: 0.3
                    align: "center"
                    horizontal: false
                    order: 1
            grid:
                hoverable: true
                borderWidth: 1
                borderColor: "#eeeeee"
            tooltip: true
            tooltipOpts:
                defaultTheme: false  
            colors: [$scope.color.success, $scope.color.info, $scope.color.warning, $scope.color.danger]


        # Note: flot.orderBar.js is needed in order to seperate bars side by side like Morris.js, example here: http://jsfiddle.net/pmking/WbuAF/
        $scope.barChart1 = {}
        $scope.barChart1.data = [
                label: "Value A"
                data: barChart.data1
                bars:
                    order: 0
            ,
                label: "Value B"
                data: barChart.data2
                bars:
                    order: 1
            ,
                label: "Value C"
                data: barChart.data3
                bars:
                    order: 2
        ]
        $scope.barChart1.options =
            series:
                stack: true
                bars:
                    show: true
                    fill: 1
                    barWidth: 0.2
                    align: "center"
                    horizontal: false
            grid:
                hoverable: true
                borderWidth: 1
                borderColor: "#eeeeee"
            tooltip: true
            tooltipOpts:
                defaultTheme: false  
            colors: [$scope.color.success, $scope.color.info, $scope.color.warning, $scope.color.danger]




        $scope.barChart3 = {}
        $scope.barChart3.data = [
                label: " A"
                data: [[1,65], [2,59], [3,90], [4,81], [5,56], [6,55], [7,40]]
                bars:
                    order: 0
                    fillColor:  { colors: [ { opacity: 0.3 }, { opacity: 0.3 } ] }
            ,
                label: " B"
                data: [[1,28], [2,48], [3,40], [4,19], [5,96], [6,27], [7,10]]
                bars:
                    order: 1
                    fillColor:  { colors: [ { opacity: 0.3 }, { opacity: 0.3 } ] }
        ]
        $scope.barChart3.options =
            series:
                stack: true
                bars:
                    show: true
                    fill: 1
                    barWidth: 0.3
                    align: "center"
                    horizontal: false
            grid:
                show: true
                aboveData: false
                color: '#eaeaea'
                hoverable: true
                borderWidth: 1
                borderColor: "#eaeaea"
            tooltip: true
            tooltipOpts:
                defaultTheme: false  
            colors: [$scope.color.gray, $scope.color.primary, $scope.color.info, $scope.color.danger]


        barChartH = {} 
        barChartH.data1 = [[85, 10], [50, 20], [55,30]]
        barChartH.data2 = [[77, 10], [60, 20], [70,30]]
        barChartH.data3 = [[100, 10], [70, 20], [55,30]]
        $scope.barChart2 = {}
        $scope.barChart2.data = [
                label: "Value A"
                data: barChartH.data1
                bars:
                    order: 1
            ,
                label: "Value B"
                data: barChartH.data2
                bars:
                    order: 2
            ,
                label: "Value C"
                data: barChartH.data3
                bars:
                    order: 3
        ]
        $scope.barChart2.options =
            series:
                stack: true
                bars:
                    show: true
                    fill: 1
                    barWidth: 1
                    align: "center"
                    horizontal: true
            grid:
                hoverable: true
                borderWidth: 1
                borderColor: "#eeeeee"
            tooltip: true
            tooltipOpts:
                defaultTheme: false  
            colors: [$scope.color.success, $scope.color.info, $scope.color.warning, $scope.color.danger]



        # Pie Chart
        $scope.pieChart = {}
        $scope.pieChart.data = [
            label: "Download Sales"
            data: 12
        ,
            label: "In-Store Sales"
            data: 30
        ,
            label: "Mail-Order Sales"
            data: 20
        ,
            label: "Online Sales"
            data: 19        
        ]
        $scope.pieChart.options =
            series:
                pie:
                    show: true
            legend:
                show: true
            grid:
                hoverable: true
                clickable: true
            colors: [$scope.color.primary, $scope.color.success, $scope.color.info, $scope.color.warning,$scope.color.danger]
            tooltip: true
            tooltipOpts:
                content: "%p.0%, %s" # thanks https://github.com/krzysu/flot.tooltip/issues/25
                defaultTheme: false            


        # Donut Chart
        $scope.donutChart = {}
        $scope.donutChart.data = [
            label: "Download Sales"
            data: 12
        ,
            label: "In-Store Sales"
            data: 30
        ,
            label: "Mail-Order Sales"
            data: 20
        ,
            label: "Online Sales"
            data: 19    
        ]
        $scope.donutChart.options =
            series:
                pie:
                    show: true
                    innerRadius: 0.5
            legend:
                show: true
            grid:
                hoverable: true
                clickable: true
            colors: [$scope.color.primary, $scope.color.success, $scope.color.info, $scope.color.warning,$scope.color.danger]
            tooltip: true
            tooltipOpts:
                content: "%p.0%, %s"
                defaultTheme: false

        # Donut Chart2
        $scope.donutChart2 = {}
        $scope.donutChart2.data = [
            label: "Download Sales"
            data: 12
        ,
            label: "In-Store Sales"
            data: 30
        ,
            label: "Mail-Order Sales"
            data: 20
        ,
            label: "Online Sales"
            data: 19
        ,
            label: "Direct Sales"
            data: 15  
        ]
        $scope.donutChart2.options =
            series:
                pie:
                    show: true
                    innerRadius: 0.45
            legend:
                show: false
            grid:
                hoverable: true
                clickable: true
            colors: ["#1BB7A0", "#39B5B9", "#52A3BB","#619CC4", "#6D90C5"]
            tooltip: true
            tooltipOpts:
                content: "%p.0%, %s"
                defaultTheme: false


])
.controller('sparklineCtrl', [
    '$scope'
    ($scope) ->

        # for widget
        $scope.demoData1 = 
            data: [3,1,2,2,4,6,4,5,2,4,5,3,4,6,4,7]
            options:
                type: 'line'
                lineColor: '#fff'
                highlightLineColor: '#fff'
                fillColor: $scope.color.success
                spotColor: false
                minSpotColor: false
                maxSpotColor: false
                width: '100%';
                height: '150px';

        # sparkline page
        $scope.simpleChart1 =
            data: [3,1,2,3,5,3,4,2]
            options:
                type: 'line'
                lineColor: $scope.color.primary
                fillColor: '#fafafa'
                spotColor: false
                minSpotColor: false
                maxSpotColor: false

        $scope.simpleChart2 =
            data: [3,1,2,3,5,3,4,2]
            options:
                type: 'bar'
                barColor: $scope.color.primary

        $scope.simpleChart3 =
            data: [3,1,2,3,5,3,4,2]
            options:
                type: 'pie'
                sliceColors: [$scope.color.primary, $scope.color.success, $scope.color.info, $scope.color.infoAlt, $scope.color.warning, $scope.color.danger]

        $scope.tristateChart1 =
            data: [1,2,-3,-5,3, 1, -4,2]
            options:
                type: 'tristate'
                posBarColor: $scope.color.success
                negBarColor: $scope.color.danger


        $scope.largeChart1 =
            data: [3,1,2,3,5,3,4,2]
            options:
                type: 'line'
                lineColor: $scope.color.info
                highlightLineColor: '#fff'
                fillColor: $scope.color.info
                spotColor: false
                minSpotColor: false
                maxSpotColor: false
                width: '100%';
                height: '150px';

        $scope.largeChart2 =
            data: [3,1,2,3,5,3,4,2]
            options:
                type: 'bar'
                barColor: $scope.color.success
                barWidth: 10
                width: '100%';
                height: '150px';

        $scope.largeChart3 =
            data: [3,1,2,3,5]
            options:
                type: 'pie'
                sliceColors: [$scope.color.primary, $scope.color.success, $scope.color.info, $scope.color.infoAlt, $scope.color.warning, $scope.color.danger]
                width: '150px';
                height: '150px';
])