delay = (ms, func) -> setTimeout func, ms

$ ->

  animation = new Animation
  $('body').on('scroll', ->
    if $('#how-it-works').offset().top < 400
      $('body').off('scroll')
      animation.runAnimation()
  )
class Animation
  constructor: ->
    @svg = Snap('#how-it-works-svg')
    @howardText = @svg.select('#hey-friend')
    @howardText.attr({opacity: 0})
    @howardBubble = @svg.select('#howard-bubble')	
    @howardBubble.attr({opacity: 0})
  
    @gymText = @svg.select('#gym-text')
    @gymText.attr({opacity: 0})
    @gymBubble = @svg.select('#gym-bubble')
    @gymBubble.attr({opacity: 0})

    @facebookText = @svg.select('#facebook-text')
    @facebookText.attr({opacity: 0})
    @facebookBubble = @svg.select('#facebook-bubble')
    @facebookBubble.attr({opacity: 0})

    sideRects = @svg.selectAll('#side-rect')
    taskBox = @svg.select('#Rectangle-14')
    taskText = @svg.select('#task-text')

    @task = @svg.group(sideRects, taskBox, taskText)
    @task.attr({opacity: 0})

    sideRects2 = @svg.selectAll('#side-rect2')
    taskBox2 = @svg.select('#Rectangle-14-2')
    taskText2 = @svg.select('#dogbook-text')

    @task2 = @svg.group(sideRects2, taskBox2, taskText2)
    @task2.attr({opacity: 0})

    @circle1 = @svg.select('#Oval-1')
    @circle2 = @svg.select('#Oval-2')
    @circle3 = @svg.select('#Oval-3')
    @circle4 = @svg.select('#Oval-4')
    @circle5 = @svg.select('#Oval-5')



  runAnimation: ->
    delay 1000, => @showHowardText()


  showHowardText: ->
    @howardText.animate({opacity: 1}, 200, =>
      @showFirstText()
    )

    @howardBubble.animate({opacity: 1}, 200)

  showFirstText: =>
    delay 1200, =>
      @gymText.animate({opacity: 1}, 200)
      @gymBubble.animate({opacity: 1}, 200, =>
        @animateCircles()
      )

  showSecondText: =>
    delay 1200, =>
      @facebookText.animate({opacity: 1}, 200)
      @facebookBubble.animate({opacity: 1}, 200, =>
        @animateCircles(secondStep: true)
      )
  
  showTask1: ->
    @task.animate({opacity: 1}, 400, =>
      @showSecondText()
    )

  showTask2: ->
    @task2.animate({opacity: 1}, 400, =>
      delay 3000, => @resetAnimation()
    )
  
  resetAnimation: ->
    
  animateCircles:(options = {})->
    length = 200
    @circle1.animate({r: '15.0', fill: 'rgb(240, 63, 63)'}, length, =>
      @circle1.animate({r: '13.5', fill: 'rgb(240, 63, 63)'}, length)
      @circle2.animate({r: '15.0', fill: 'rgb(240, 63, 63)'}, length, =>
        @circle2.animate({r: '13.5', fill: 'rgb(240, 63, 63)'}, length)
        @circle3.animate({r: '15.0', fill: 'rgb(240, 63, 63)'}, length, =>
          @circle3.animate({r: '13.5', fill: 'rgb(240, 63, 63)'}, length)
          @circle4.animate({r: '15.0', fill: 'rgb(240, 63, 63)'}, length, =>
            @circle4.animate({r: '13.5', fill: 'rgb(240, 63, 63)'}, length)
            @circle5.animate({r: '15.0', fill: 'rgb(240, 63, 63)'}, length,  =>
              @circle5.animate({r: '13.5', fill: 'rgb(240, 63, 63)'}, length)
              if options.secondStep
                @showTask2()
              else
                @showTask1()

            )
          )
        )
      )
    )
  