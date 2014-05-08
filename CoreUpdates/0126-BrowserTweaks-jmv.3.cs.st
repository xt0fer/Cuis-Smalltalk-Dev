'From Squeak3.7 of ''4 September 2004'' [latest update: #5989] on 19 March 2009 at 12:50:11 pm'!
	| row switchHeight divider |
	row := (OldAlignmentMorph newColumn)
				hResizing: #spaceFill;
				vResizing: #spaceFill;
				layoutInset: 0;
				borderWidth: 1;
				layoutPolicy: OldProportionalLayout new.
	switchHeight := Preferences standardDefaultTextFont height + 4.
	self addMorphicSwitchesTo: row
		at: (OldLayoutFrame fractions: (0 @ 1 corner: 1 @ 1)
				offsets: (0 @ (1 - switchHeight) corner: 0 @ 0)).
	divider := OldBorderedSubpaneDividerMorph forTopEdge.
	Preferences alternativeWindowLook 
		ifTrue: 
			[divider
				extent: 4 @ 4;
				color: Color transparent;
				borderColor: #raised;
				borderWidth: 2].
	row addMorph: divider
		fullFrame: (OldLayoutFrame fractions: (0 @ 1 corner: 1 @ 1)
				offsets: (0 @ switchHeight negated corner: 0 @ (1 - switchHeight))).
	row addMorph: aListPane
		fullFrame: (OldLayoutFrame fractions: (0 @ 0 corner: 1 @ 1)
				offsets: (0 @ 0 corner: 0 @ switchHeight negated)).
	window addMorph: row
		fullFrame: (OldLayoutFrame fractions: nominalFractions
				offsets: (0 @ verticalOffset corner: 0 @ 0)).
	row 
		on: #mouseEnter
		send: #paneTransition:
		to: window.
	row 
		on: #mouseLeave
		send: #paneTransition:
		to: window! !
	| instanceSwitch divider1 divider2 commentSwitch classSwitch row aColor |
	instanceSwitch := OldPluggableButtonMorph 
				on: self
				getState: #instanceMessagesIndicated
				action: #indicateInstanceMessages.
	instanceSwitch
		label: 'instance';
		askBeforeChanging: true;
		borderWidth: 0.
	commentSwitch := OldPluggableButtonMorph 
				on: self
				getState: #classCommentIndicated
				action: #plusButtonHit.
	commentSwitch
		label: '?' asText allBold;
		askBeforeChanging: true;
		setBalloonText: 'class comment';
		borderWidth: 0.
	classSwitch := OldPluggableButtonMorph 
				on: self
				getState: #classMessagesIndicated
				action: #indicateClassMessages.
	classSwitch
		label: 'class';
		askBeforeChanging: true;
		borderWidth: 0.
	divider1 := OldBorderedSubpaneDividerMorph vertical.
	divider2 := OldBorderedSubpaneDividerMorph vertical.
	Preferences alternativeWindowLook 
		ifTrue: 
			[divider1
				extent: 4 @ 4;
				borderWidth: 2;
				borderRaised;
				color: Color transparent.
			divider2
				extent: 4 @ 4;
				borderWidth: 2;
				borderRaised;
				color: Color transparent].
	row := (OldAlignmentMorph newRow)
				hResizing: #spaceFill;
				vResizing: #spaceFill;
				layoutInset: 0;
				borderWidth: 0;
				addMorphBack: instanceSwitch;
				addMorphBack: divider1;
				addMorphBack: commentSwitch;
				addMorphBack: divider2;
				addMorphBack: classSwitch.
	aColor := Color colorFrom: self class windowColor.
	row color: aColor duller.	"ensure matching button divider color. (see #paneColor)"
	Preferences alternativeWindowLook ifTrue: [aColor := aColor muchLighter].
	{ 
		instanceSwitch.
		commentSwitch.
		classSwitch} do: 
				[:m | 
				m
					color: aColor;
					onColor: aColor twiceDarker offColor: aColor;
					hResizing: #spaceFill;
					vResizing: #spaceFill].
	^row! !
	"Create a pluggable version a Browser on just a single class."

	| window dragNDropFlag hSepFrac switchHeight mySingletonClassList |
	window := (OldSystemWindow labelled: 'later') model: self.
	dragNDropFlag := false.
	hSepFrac := 0.3.
	switchHeight := Preferences standardCodeFont height + 4.
	mySingletonClassList := OldPluggableListMorph 
				on: self
				list: #classListSingleton
				selected: #indexIsOne
				changeSelected: #indexIsOne:
				menu: #classListMenu:shifted:
				keystroke: #classListKey:from:.
	mySingletonClassList enableDragNDrop: dragNDropFlag.
	self 
		addLowerPanesTo: window
		at: (0 @ hSepFrac corner: 1 @ 1)
		with: editString.
	window addMorph: mySingletonClassList
		fullFrame: (OldLayoutFrame fractions: (0 @ 0 corner: 0.5 @ 0)
				offsets: (0 @ 0 corner: 0 @ switchHeight)).
	self addMorphicSwitchesTo: window
		at: (OldLayoutFrame fractions: (0.5 @ 0 corner: 1.0 @ 0)
				offsets: (0 @ 0 corner: 0 @ switchHeight)).
	window addMorph: self buildMorphicMessageCatList
		fullFrame: (OldLayoutFrame fractions: (0 @ 0 corner: 0.5 @ hSepFrac)
				offsets: (0 @ switchHeight corner: 0 @ 0)).
	window addMorph: self buildMorphicMessageList
		fullFrame: (OldLayoutFrame fractions: (0.5 @ 0 corner: 1.0 @ hSepFrac)
				offsets: (0 @ switchHeight corner: 0 @ 0)).
	window setUpdatablePanesFrom: #(#messageCategoryList #messageList).
	^window! !
	"Create a pluggable version of all the views for a Browser, including views and controllers."

	| window hSepFrac switchHeight mySingletonList nextOffsets |
	window := (OldSystemWindow labelled: 'later') model: self.
	hSepFrac := 0.3.
	switchHeight := Preferences standardCodeFont height + 4.
	mySingletonList := OldPluggableListMorph 
				on: self
				list: #systemCategorySingleton
				selected: #indexIsOne
				changeSelected: #indexIsOne:
				menu: #systemCatSingletonMenu:
				keystroke: #systemCatSingletonKey:from:.
	mySingletonList enableDragNDrop: false.
	mySingletonList hideScrollBarsIndefinitely.
	window addMorph: mySingletonList
		fullFrame: (OldLayoutFrame fractions: (0 @ 0 corner: 1 @ 0)
				offsets: (0 @ 0 corner: 0 @ switchHeight)).
	self 
		addClassAndSwitchesTo: window
		at: (0 @ 0 corner: 0.3333 @ hSepFrac)
		plus: switchHeight.
	nextOffsets := 0 @ switchHeight corner: 0 @ 0.
	window addMorph: self buildMorphicMessageCatList
		fullFrame: (OldLayoutFrame 
				fractions: (0.3333 @ 0 corner: 0.6666 @ hSepFrac)
				offsets: nextOffsets).
	window addMorph: self buildMorphicMessageList
		fullFrame: (OldLayoutFrame fractions: (0.6666 @ 0 corner: 1 @ hSepFrac)
				offsets: nextOffsets).
	self 
		addLowerPanesTo: window
		at: (0 @ hSepFrac corner: 1 @ 1)
		with: editString.
	window 
		setUpdatablePanesFrom: #(#classList #messageCategoryList #messageList).
	^window! !
	| notifyPane window contentTop extentToUse |
	self expandStack.
	window := (OldPreDebugWindow labelled: label) model: self.
	contentTop := 0.2.
	extentToUse := 650 @ 320.	"nice and wide to show plenty of the error msg"
	window addMorph: (self buttonRowForPreDebugWindow: window)
		frame: (0 @ 0 corner: 1 @ contentTop).
	messageString notNil 
		ifFalse: 
			[notifyPane := OldPluggableListMorph 
						on: self
						list: #contextStackList
						selected: #contextStackIndex
						changeSelected: #debugAt:
						menu: nil
						keystroke: nil]
		ifTrue: 
			[notifyPane := OldPluggableTextMorph 
						on: self
						text: nil
						accept: nil
						readSelection: nil
						menu: #debugProceedMenu:.
			notifyPane
				editString: (self preDebugNotifierContentsFrom: messageString);
				askBeforeDiscardingEdits: false].
	window addMorph: notifyPane frame: (0 @ contentTop corner: 1 @ 1).
	"window deleteCloseBox.
		chickened out by commenting the above line out, sw 8/14/2000 12:54"
	window setBalloonTextForCloseBox.
	^window openInWorldExtent: extentToUse! !
	| fileListMorph row buttonHeight fileListTop divider dividerDelta buttons |
	fileListMorph := OldPluggableListMorph 
				on: aFileList
				list: #fileList
				selected: #fileListIndex
				changeSelected: #fileListIndex:
				menu: #fileListMenu:.
	fileListMorph
		enableDrag: true;
		enableDrop: false.
	aFileList wantsOptionalButtons 
		ifTrue: 
			[buttons := aFileList optionalButtonRow.
			divider := OldBorderedSubpaneDividerMorph forBottomEdge.
			dividerDelta := 0.
			Preferences alternativeWindowLook 
				ifTrue: 
					[buttons color: Color transparent.
					buttons submorphsDo: 
							[:m | 
							m
								borderWidth: 2;
								borderColor: #raised].
					divider
						extent: 4 @ 4;
						color: Color transparent;
						borderColor: #raised;
						borderWidth: 2.
					fileListMorph borderColor: Color transparent.
					dividerDelta := 3].
			row := (OldAlignmentMorph newColumn)
						hResizing: #spaceFill;
						vResizing: #spaceFill;
						layoutInset: 0;
						borderWidth: 2;
						layoutPolicy: OldProportionalLayout new.
			buttonHeight := self defaultButtonPaneHeight.
			row addMorph: buttons
				fullFrame: (OldLayoutFrame fractions: (0 @ 0 corner: 1 @ 0)
						offsets: (0 @ 0 corner: 0 @ buttonHeight)).
			row addMorph: divider
				fullFrame: (OldLayoutFrame fractions: (0 @ 0 corner: 1 @ 0)
						offsets: (0 @ buttonHeight corner: 0 @ buttonHeight + dividerDelta)).
			row addMorph: fileListMorph
				fullFrame: (OldLayoutFrame fractions: (0 @ 0 corner: 1 @ 1)
						offsets: (0 @ buttonHeight + dividerDelta corner: 0 @ 0)).
			window addMorph: row
				fullFrame: (OldLayoutFrame fractions: upperFraction
						offsets: (0 @ offset corner: 0 @ 0)).
			Preferences alternativeWindowLook 
				ifTrue: [row borderWidth: 2]
				ifFalse: [row borderWidth: 0]]
		ifFalse: 
			[fileListTop := 0.
			window addMorph: fileListMorph frame: (0.3 @ fileListTop corner: 1 @ 0.3)]! !
	"Open a morphic view of a FileList on the default directory."

	| dir aFileList window upperFraction offset |
	dir := FileDirectory default.
	aFileList := self new directory: dir.
	window := (OldSystemWindow labelled: dir pathName) model: aFileList.
	upperFraction := 0.3.
	offset := 0.
	self 
		addVolumesAndPatternPanesTo: window
		at: (0 @ 0 corner: 0.3 @ upperFraction)
		plus: offset
		forFileList: aFileList.
	self 
		addButtonsAndFileListPanesTo: window
		at: (0.3 @ 0 corner: 1.0 @ upperFraction)
		plus: offset
		forFileList: aFileList.
	window addMorph: (OldPluggableTextMorph 
				on: aFileList
				text: #contents
				accept: #put:
				readSelection: #contentsSelection
				menu: #fileContentsMenu:shifted:)
		frame: (0 @ 0.3 corner: 1 @ 1).
	^window openInWorld! !