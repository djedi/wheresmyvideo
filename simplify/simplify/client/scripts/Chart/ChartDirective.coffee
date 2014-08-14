'use strict'

angular.module('app.chart.directives', [])

.directive('gaugeChart', [ -> # The online docs seems outdate, i.e. not working
    return {
        restrict: 'A'
        scope:
            data: '='
            options: '='
        link: (scope, ele, attrs) ->
            data = scope.data
            options = scope.options

            gauge = new Gauge(ele[0]).setOptions(options)
            gauge.maxValue = data.maxValue
            gauge.animationSpeed = data.animationSpeed
            gauge.set(data.val)
    }
])
.directive('chartjsChart', [ ->
    return {
        restrict: 'A'
        scope:
            data: '='
            options: '='
            type: '='
        link: (scope, ele, attrs) ->
            data = scope.data
            options = scope.options
            type = scope.type.toLowerCase()

            # console.log type
            # console.log attrs.data
            # console.log options
            ctx = ele[0].getContext("2d")
            switch type
                when 'line'
                    myChart     = new Chart(ctx).Line(data, options)
                when 'bar'
                    myChart     = new Chart(ctx).Bar(data, options)
                when 'radar'
                    myChart     = new Chart(ctx).Radar(data, options)
                when 'polararea'
                    myChart     = new Chart(ctx).PolarArea(data, options)
                when 'pie'
                    myChart     = new Chart(ctx).Pie(data, options)
                when 'doughnut'
                    myChart     = new Chart(ctx).Doughnut(data, options)
    }
])
.directive('chartjsWithLegend', [ ->
    return {
        restrict: 'A'

        link: (scope, ele, attrs) ->

            canvas = ele[0]

            moduleData = [
                value: 300,
                color: "#BF616A",
                highlight: "rgba(191,97,106,0.9)"
                label: "Red"
            ,
                value: 50,
                color: "#A3BE8C",
                highlight: "rgba(163,190,140,0.9)"
                label: "Green"
            ,
                value: 100,
                color: "#EBCB8B",
                highlight: "rgba(235,203,139,0.9)"
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

            # 
            moduleDoughnut = new Chart(canvas.getContext("2d")).Doughnut(moduleData, {
                responsive: true
            })

            # 
            legendHolder = document.createElement("div")
            legendHolder.innerHTML = moduleDoughnut.generateLegend()

            helpers = Chart.helpers
            # Include a html legend template after the module doughnut itself
            helpers.each legendHolder.firstChild.childNodes, (legendNode, index) ->
                helpers.addEvent legendNode, "mouseover", ->
                    activeSegment = moduleDoughnut.segments[index]
                    activeSegment.save()
                    activeSegment.fillColor = activeSegment.highlightColor
                    moduleDoughnut.showTooltip [activeSegment]
                    activeSegment.restore()
                    return

                return

            helpers.addEvent legendHolder.firstChild, "mouseout", ->
                moduleDoughnut.draw()
                return

            canvas.parentNode.parentNode.appendChild legendHolder.firstChild
         
    }
])
.directive('flotChart', [ ->
    return {
        restrict: 'A'
        scope:
            data: '='
            options: '='
        link: (scope, ele, attrs) ->
            data = scope.data
            options = scope.options
            
            # console.log data
            # console.log options

            plot = $.plot(ele[0], data, options);

    }
])
.directive('flotChartRealtime', [ ->
    return {
        restrict: 'A'
        link: (scope, ele, attrs) ->
            data = []
            totalPoints = 300
            getRandomData = ->
                data = data.slice(1)  if data.length > 0
                
                # Do a random walk
                while data.length < totalPoints
                    prev = (if data.length > 0 then data[data.length - 1] else 50)
                    y = prev + Math.random() * 10 - 5
                    if y < 0
                        y = 0
                    else y = 100  if y > 100
                    data.push y
                
                # Zip the generated y values with the x values
                res = []
                i = 0

                while i < data.length
                    res.push [
                        i
                        data[i]
                    ]
                    ++i
                res

            update = ->
                plot.setData [getRandomData()]
                
                # Since the axes don't change, we don't need to call plot.setupGrid()
                plot.draw()
                setTimeout update, updateInterval
                return
            data = []
            totalPoints = 300
            updateInterval = 200
            plot = $.plot(ele[0], [getRandomData()],
                series:
                    lines:
                        show: true
                        fill: true
                    shadowSize: 0
                yaxis:
                    min: 0
                    max: 100
                xaxis:
                    show: false
                grid:
                    hoverable: true
                    borderWidth: 1
                    borderColor: '#eeeeee'
                colors: ["#5B90BF"]
            )
            update()

    }
])
.directive('sparkline', [ ->
    return {
        restrict: 'A'
        scope:
            data: '='
            options: '='
        link: (scope, ele, attrs) ->
            data = scope.data
            options = scope.options
            sparkResize = undefined

            sparklineDraw = ->
                ele.sparkline(data, options)

            $(window).resize( (e) ->
                clearTimeout(sparkResize)
                sparkResize = setTimeout(sparklineDraw, 200)
            )

            sparklineDraw()
    }
])