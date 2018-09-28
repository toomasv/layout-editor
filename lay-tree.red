Red [
	Author: "Toomas Vooglaid"
	Date: 2018-09-22
	Last: 2018-09-28
]
#include %../drawing/pallette1.red
context [
	cf: sz: wz: _new: typ: name: fc: fc2: none ; win: 
	i: 0
	sc: system/view/screens/1
	facename: make map! 10
	drag: [drag-on: 'down]
	short-text: function [title-text /with def][
		view/flags [
			title title-text 
			result: field 100 focus 
			on-enter [result: result/text unview]
			button "OK" [result: result/text unview]
			do [if with [pane/1/text: def]]
		][modal popup] 
		result
	]
	ask-text: does [short-text "Enter text"]
	long-text: function [title-text /with def][
		view/flags/options [
			title title-text 
			below
			result: area 300x100 focus
			return
			button "OK" [result: result/text unview]
			button "Cancel" [result: copy "" unview]
			do [if with [pane/1/text: def]]
		][modal popup resize][
			actors: object [
				on-resizing: func [f e][
					result/size: f/size - 92x20
					foreach-face/with f [
						face/offset/x: f/size/x - face/size/x - 10
					][face/type = 'button]
					show result
				]
			]
		]
		either string? result [result][copy ""]
	]
	ask-long-text: does [long-text "Enter text"]
	make-mobile: func [lay][
		case/all [
			not lay/actors [lay/actors: object copy []]
			not attempt [lay/actors/on-moving] [lay/actors: make lay/actors [on-moving: func [face event][]]]
			not attempt [lay/actors/on-resizing] [lay/actors: make lay/actors [on-resizing: func [face event][]]]
		]
		lay/flags: [resize]
		lay/extra: #(offset: 0x0 size: 0x0)
		append body-of :lay/actors/on-moving bind compose [face/extra/offset: (cf) * face/offset] :lay/actors/on-moving
		append body-of :lay/actors/on-resizing bind compose [face/extra/size: (cf) * face/size] :lay/actors/on-resizing
	]
	face-data: [
		;panel [
			style fld: field extra false on-change [face/extra: true]
			style are: area 200x75 extra false on-change [face/extra: true]
			text "type: " type_: fld (form type) disabled return
			text "offset: " offset_: fld (form offset) return
			text "size: " size_: fld (form size) return
			text "text: " text_: fld 200x26 (form any [text ""]) return
			;text "image: " image_: button "Select" [] return   ; TBD
			text "color: " color_: fld (form any [color ""]) return
			text "menu: " menu_: are (either menu [mold/only menu][""]) return
			text "data: " data_: fld 200x26 (either data [mold/only data][""]) return
			text "enabled?: " enabled?_: check (enabled?) extra false return
			text "visible?: " visible?_: check (visible?) extra false return
			text "selected: " selected_: fld (form any [selected ""]) return
			text "flags: " flags_: fld 200x26 (either flags [mold/only flags][""]) return
			text "options: " options_: fld 200x26 (either options [mold/only options][""]) return ;[style: base vid-align: top at-offset: none]
			;parent ;make object! [...]
			;pane
			text "rate: " rate_: fld (form any [rate ""]) return
			text "para: " para_: fld 200x26 (either para [mold/only para][""]) return
			text "font: " font_: fld 200x26 (either font [mold/only font][""]) return
			text "actors: " actors_: are wrap (either actors [mold/only actors][""]) return
			text "draw: " draw_: are wrap (either draw [mold/only draw][""]) return
		;]
		button "Change" [
			;_face: (probe my-face/type my-face)
			foreach [txt fld] face/parent/pane [
				if fld/extra [
					attr: to-word copy/part txt/text find txt/text #":"
					switch/default attr [
						type []
						text [extra/extra/text: fld/text]
						offset [extra/offset: cf * extra/extra/offset: fld/data]
						size [
							extra/size: cf * extra/extra/size: fld/data
							extra/draw/9: (extra/draw/5: extra/draw/10: extra/size - 1) - 4
						]
					][extra/extra/:attr: compose bind load fld/text extra/extra]
				]
			]
		] 
		button "Close" [unview]
	]
	new-face: [
		type: 'base ;(to-lit-word typ) 
		color: switch/default lay/type [window [white] panel tab-panel group-box base [snow]][silver]
		offset: either lay/offset [cf * lay/offset][none]
		size: cf * lay/size
		text: form name 
		extra: lay
		flags: 'all-over
		pane: either find [window panel tab-panel group-box base] lay/type [make block! 5][none]
		draw: compose [pen gray box 0x0 (size - 1) fill-pen gray box (size - 5) (size - 1)]
		menu: compose [
			"Face" [
				"All" 		_face
				"Text" 		_text
				"Offset" 	_offset
				"Size" 		_size
				"Color" 	_color
				"Menu" 		_menu
				"Data" 		_data 	;------v TBD
				"Disable" 	_disable
				"Hide" 		_hide
				"Selected" 	_selected
				"Flags" 	_flags
				"Options" 	_options
				"Rate" 		_rate
				"Para" 		_para
				"Font" 		_font
				"Draw" 		_draw
				"Actor" [
					"On-down" on-down "On-up" on-up 
					"On-mid-down" on-mid-down "On-mid-up" on-mid-up 
					"On-alt-down" on-alt-down "On-alt-up" on-alt-up 
					"On-aux-down" on-aux-down "On-aux-up" on-aux-up 
					"On-time" on-time 
					"On-scroll" on-scroll "On-wheel" on-wheel 
					"On-drag-start" on-drag-start "On-drag" on-drag "On-drop" on-drop 
					"On-click" on-click "On-dbl-click" on-dbl-click 
					"On-over" on-over 
					"On-key" on-key "On-key-down" on-key-down "On-key-up" on-key-up 
					"On-focus" on-focus "On-unfocus" on-unfocus 
					"On-select" on-select "On-change" on-change 
					"On-enter" on-enter "On-menu" on-menu "On-close" on-close 
					"On-move" on-move "On-resize" on-resize "On-moving" on-moving "On-resizing" on-resizing 
					"On-create" on-create "On-created" on-created
					;"On-detect" on-detect ;"On-drawing" on-drawing ;"On-ime" on-ime ;"On-zoom" on-zoom 
					;"On-pan" on-pan ;"On-rotate" on-rotate ;"On-two-tap" on-two-tap ;"On-press-tap" on-press-tap 
				]
			]
			(if find [window panel group-box base] lay/type [["Insert" [
				"VID" vid "base" base "text" text "button" button 
				"check" check "radio" radio "field" field "rich-text" rich-text
				"area" area "text-list" text-list "drop-list" drop-list 
				"drop-down" drop-down "progress" progress "slider" slider "scroller" scroller
				"camera" camera "panel" panel "tab-panel" tab-panel "group-box" group-box 
				"h1" h1 "h2" h2 "h3" h3 "h4" h4 "h5" h5 "box" box "image" image
			]]])
			(if lay/type = 'tab-panel [["Insert" ["Tab" tab]]])
			"Order" [
				"Back" back
				"Backward" backward
				"Forward" forward
				"Front" front
			]
			"Cut" _cut
			"Copy" _copy ;TBD
			(if find [window panel group-box base] lay/type [["Paste" _paste]])
			"Delete" _delete
		]
		actors: object [
			pos: lay: ofs: diff: change-size: none
			on-down: func [face event][
				pos: event/offset
				if event/ctrl? [pos: round/to pos 5]
				either change-size: either within? event/offset face/size - 7 8x8 [yes][no] [
					diff: face/size - event/offset
				][
					ofs: face/offset
				]
				'done
			]
			on-over: func [face event][
				if event/down? [
					either change-size [
						face/size: either event/ctrl? [round/to event/offset + diff 5][event/offset + diff]
						face/draw/9: (face/draw/5: face/draw/10: face/size - 1) - 4
						face/extra/size: face/size / cf
					][
						df: event/offset - pos
						face/offset: either event/ctrl? [round/to ofs + df 5][ofs + df]
						face/extra/offset: face/offset / cf
						ofs: face/offset
					]
				]
				'done
			]
			on-menu: func [face event /local actor code][
				pos: event/offset
				if event/ctrl? [pos: round/to pos 5]
				switch event/picked [
					_face [
						view/flags/options compose bind copy/deep face-data :face/extra [resize][
							actors: object [
								on-resizing: func [win event][
									foreach-face/with win [
										face/size/x: win/size/x - face/offset/x - 10
									][
										all [
											find [area field] face/type 
											find [26 75] face/size/y 
											(face/offset/x + face/size/x) > (win/size/x - 30)
										]
									]
								]
							]
						] 'done
					]
					_offset [
						face/extra/offset: load short-text/with "Edit offset" form face/extra/offset 
						face/offset: face/extra/offset * cf 'done
					] ;; Only win works?
					_size [
						face/extra/size: load short-text/with "Edit size" form face/extra/size 
						face/draw/5: (face/size: face/extra/size * cf) - 1 'done
					] 
					_color [face/extra/color: get select-color 'done]
					_text [face/extra/text: short-text/with "Enter text" face/extra/text 'done]
					_menu [face/extra/menu: load short-text/with "Enter menu" mold/only face/extra/menu 'done]
					_data [face/extra/data: load long-text/with "Enter data" mold/only face/extra/data 'done]

					on-time on-scroll on-down on-up on-mid-down on-mid-up on-alt-down on-alt-up on-aux-down on-aux-up on-wheel 
					on-drag-start on-drag on-drop on-click on-dbl-click on-over on-key on-key-down on-key-up on-focus on-unfocus 
					on-select on-change on-enter on-menu on-close on-move on-resize on-moving on-resizing on-create on-created
					;on-drawing on-ime on-pan on-rotate on-two-tap on-press-tap on-zoom 
					[
						actor: event/picked
						case/all [
							not face/extra/actors [face/extra/actors: object copy []]
							not attempt [:face/extra/actors/:actor] [
								face/extra/actors: make face/extra/actors compose [
									(to-set-word actor) func [face event][]
								]
							]
						]
						code: copy body-of :face/extra/actors/:actor
						bind head insert clear body-of :face/extra/actors/:actor 
							load long-text/with "Enter actor's code" mold/only code 
							:face/extra/actors/:actor

						;if find [resize resizing] actor [
						;	face/extra/flags: [resize]
						;	if actor = 'resizing [
						;		append body-of :face/extra/actors/on-resizing bind compose [face/extra/size: (cf) * face/size] :face/extra/actors/on-resizing
						;	]
						;]
						'done
					]

					vid [
						append face/extra/pane lay: layout/only load/all long-text "Enter VID"
						lay-tree/with lay face 
						'done
					]
					base text button check radio field area text-list drop-list drop-down rich-text
						progress slider scroller camera panel tab-panel group-box h1 h2 h3 h4 h5 box image [
						either event/picked = 'tab-panel [
							append face/extra/pane lay: first layout/only [tab-panel ["One" []]]
						][
							template: system/view/VID/styles/(event/picked)/template
							if event/picked = 'group-box [put template 'size load short-text "Enter size"]
							append face/extra/pane lay: make face! system/view/VID/styles/(event/picked)/template 
							case/all [
								find [window panel group-box base] lay/type [lay/pane: copy []]
								find [text group-box] lay/type [lay/text: short-text "Enter text"]
							]
						]
						lay/offset: pos / cf
						lay-tree/with lay face
						'done
					]
					tab [
						tab: short-text "Enter tab name"
						append face/extra/pane lay: first layout/only compose [panel white (face/extra/size - 1) []]
						append face/extra/data tab
						lay-tree/with lay face
						'done
					]
					
					back [
						move found: find face/extra/parent/pane face/extra head found
						move found: find face/parent/pane face head found
						'done
					]
					backward [
						move found: find face/extra/parent/pane face/extra back found
						move found: find face/parent/pane face back found
						'done
					]
					forward [
						move found: find face/extra/parent/pane face/extra next found
						move found: find face/parent/pane face next found
						'done
					]
					front [
						move found: find face/extra/parent/pane face/extra tail found
						move find found: face/parent/pane face tail found
						'done
					]
					
					_cut [
						fc: take find face/parent/pane face 
						fc2: take find fc/extra/parent/pane fc/extra
						'done
					]
					_copy [ ;TBD
						;fc2: copy/deep face/extra
						'done
					]
					_paste [
						;foreach ev exclude copy system/catalog/accessors/event! [face window] [print [form ev event/:ev]]
						fc/offset: pos ;event/offset 
						fc2/offset: pos / cf ;event/offset / cf 
						append face/pane fc 
						append face/extra/pane fc2
						'done
					]
					_delete [
						remove find face/parent/pane face 
						remove find face/extra/parent/pane face/extra
						'done
					]
				]
			]
		]
	]
	set 'lay-tree func [lay  /with pa /local new window?][
		either block? lay [
			forall lay [lay-tree/with lay/1 pa]
		][
			if window?: lay/type = 'window [
				sz: sc/size 
				cf: .5
				pa: win: make face! copy [
					type: 'window 
					offset: 5x35 
					size: cf * sz 
					pane: copy [] 
				]
				append win/pane make face! [
					type: 'base 
					offset: 0x0 
					size: win/size 
					color: snow 
					menu: ["Insert window" window] 
					extra: sc
					actors: object [
						lay: pos: none
						on-down: func [face event][pos: event/offset]
						on-menu: func [face event][
							append sc/pane lay: make face! system/view/VID/styles/window/template 
							lay/offset: pos / cf show lay
							make-mobile lay
							append win/pane new: make face! bind compose new-face self
							lay/extra: new
						]
					]
				]
				win/visible?: no
				view/no-wait win
				lay/visible?: no
				view/no-wait lay
			]
			if window?: lay/type = 'window [make-mobile :lay]
			name: load rejoin [lay/type facename/(lay/type): 1 + any [facename/(lay/type) 0]]
			append pa/pane new: make face! bind compose new-face :lay-tree
			;if pa/extra/type = 'tab-panel
			set name lay
			lay/extra: new
			if lay/pane [foreach l lay/pane [lay-tree/with l new]]
			if window? [win/visible?: yes lay/visible?: yes do-events] ;lo: lay 
		]
	]
]
comment [
  ; Some examples
  lay-tree layout [size 800x600]
	lay-tree layout [below panel [text 40 "Probe" field 250] box 300x300 white]
]
