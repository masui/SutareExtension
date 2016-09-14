texts = []
get_text = (element) ->
  if element.text
    texts.push ('' + element.text())
  for c in element.children()
    if c.id
      get_text $('#' + c.id)

days_since_lastmodified = ->
  date = new Date(document.lastModified)
  now = new Date()
  (now.getTime() - date.getTime()) / (24 * 60 * 60 * 1000)

days_since_writtendate = ->
  get_text $('body')
  now = new Date()
  for text in texts
    if m = text.match /(\d\d\d\d)年(\d\d?)月(\d\d?)日/
      date = new Date("#{m[1]}/#{m[2]}/#{m[3]}")
  if date
    (now.getTime() - date.getTime()) / (24 * 60 * 60 * 1000)
  else
    0

do_sutare = ->
  days = days_since_lastmodified()  # lastModified()が使えた
  if days < 1.0
    days = days_since_writtendate()

  if days > 30
    [s1, s2] = ['ひと月ぐらい', '前のものです']
    [s1, s2] = ['3ヶ月ぐらい',  '前のものです'] if days > 100
    [s1, s2] = ['1年近く',      '前のものです'] if days > 300
    [s1, s2] = ['2年近く',      '前のものです'] if days > 600
    [s1, s2] = ['絶望的に',     '古いです']     if days > 1000

    div = $('<div>')
      .css 'position','absolute'
      .css 'width','100%'
      .css 'height','100%'
      .css 'top','0'
      .css 'left','0'
      .css 'background-color','#ff0'
      .css 'opacity', '0.4'
      .css 'pointer-events', 'none'    # イベントが透過するように
      .css 'font-size', '100px'
      .css 'line-height', '100px'
      .css 'text-align', 'center'
      .css 'background-image', 'url("http://pitecan.com/sutare/test1.jpg")'
    div.append $('<br/>')
    div.append $('<span>').text 'このページは'
    div.append $('<br/>')
    div.append $('<span>').text s1
    div.append $('<br/>')
    div.append $('<span>').text s2

    $('body').append div

    div.animate
      opacity: 0
    ,
      duration: 6000
      complete: -> div.remove()

maybe_old = ->
  fresh_sites = [
    'twitter'
    'tumblr'
    'facebook'
    'amazon'
    ]
  old = true
  for site in fresh_sites
    old = false if location.href.match RegExp(site,'i')
  old

$ ->
  if maybe_old()
    setTimeout do_sutare, 1000
