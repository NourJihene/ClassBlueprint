"
I am a small class representing the legend of the ClassBlueprint visualization
"
Class {
	#name : #CBLegend,
	#superclass : #Object,
	#classInstVars : [
		'legendState'
	],
	#category : #'Moose-Blueprint-Visualization-Models'
}

{ #category : #building }
CBLegend class >> build [ 
	^ self new 
			build
]

{ #category : #building }
CBLegend class >> buildFor: aVisualization [ 
	^ self new 
		buildFor: aVisualization 
]

{ #category : #accessing }
CBLegend class >> legendState [

	^ legendState ifNil: [  false ]
]

{ #category : #accessing }
CBLegend class >> legendState: aBoolean [

	 legendState := aBoolean
]

{ #category : #'as yet unclassified' }
CBLegend >> attributeInfo [

	| attributeBox attributeLabel composite widthLine heightLine |
	attributeBox := RSBox new.
	attributeLabel := RSLabel new text: 'Attribute'.
	attributeBox extent: attributeLabel extent + 10.
	attributeBox
		noPaint;
		withBorder.
	widthLine := RSLine new
		             startPoint: 0 @ 0;
		             endPoint: attributeBox width @ 0;
		             marker: self marker;
		             yourself.
	heightLine := RSLine new
		              startPoint: 0 @ 0;
		              endPoint: 0 @ attributeBox height;
		              marker: self marker;
		              yourself.
	RSVerticalLineLayout new
		gapSize: 5;
		on: { 
				attributeBox.
				widthLine }.
	RSHorizontalLineLayout new
		gapSize: 5;
		on: { 
				attributeBox.
				heightLine }.
	attributeLabel position: attributeBox position.
	composite := { 
		             attributeBox.
		             attributeLabel.
		             widthLine.
		             heightLine } asGroup asShape.
	^ composite
]

{ #category : #'as yet unclassified' }
CBLegend >> attributeboxDescription [

	| widthLabel heightLabel attributeBox |
	widthLabel := RSLabel new text: 'Number of external accesses'.
	heightLabel := RSLabel new text: 'Number of internal accesses'.
	attributeBox := self attributeInfo.
	RSVerticalLineLayout new
		gapSize: 5;
		on: { 
				attributeBox.
				widthLabel }.
	RSHorizontalLineLayout new
		gapSize: 5;
		on: { 
				attributeBox.
				heightLabel }.
	^ { 
		  attributeBox.
		  widthLabel.
		  heightLabel } asGroup asShape
		  padding: (Margin
				   left: 0
				   top: 10
				   right: 0
				   bottom: 0);
		  yourself
]

{ #category : #building }
CBLegend >> buildFor: aVisualization [

	| legend |
	legend := RSLegend new.
	legend container: aVisualization canvas.
	legend defaultBox withBorder.

	self legendInfo keysAndValuesDo: [ :key :value | 
		legend text: key withBoxColor: value ].
	legend layout layout gapSize: self gapSize.
	legend shapes
		add: self methodBoxDescription;
		add: self attributeboxDescription.
	legend legendDo: [ :shape | 
		shape
			withBorder;
			padding: 20;
			color: (Color white alpha: 0.95) ].
	legend location
		outer;
		right;
		offset: 70 @ -200.
	legend
		beFixedWithTitle: 'Legend';
		build.
	aVisualization canvas fixedShapes
		select: [ :each | each class = RSComposite ]
		thenDo: [ :each | 
			self class legendState ifFalse: [ each click ].
			each when: RSMouseClick send: #onClick to: self ].
	^ legend
]

{ #category : #accessing }
CBLegend >> gapSize [

	^ 3
]

{ #category : #building }
CBLegend >> legendInfo [

	^ MiNClassBlueprintPalette new colorsDictionary
]

{ #category : #constants }
CBLegend >> marker [ 
	^ 	RSShapeFactory arrow
		          size: 10;
		          color: Color black;
		          yourself.
]

{ #category : #'as yet unclassified' }
CBLegend >> methodBoxDescription [

	| widthLabel heightLabel methodBox |
	widthLabel := RSLabel new text: 'Number of invocations'.
	heightLabel := RSLabel new text: 'Number of lines of code'.
	methodBox := self methodInfo.
	RSVerticalLineLayout new
		gapSize: 5;
		on: { 
				methodBox.
				widthLabel }.
	RSHorizontalLineLayout new
		gapSize: 5;
		on: { 
				methodBox.
				heightLabel }.
	^ { 
		  methodBox.
		  widthLabel.
		  heightLabel } asGroup asShape
		  padding: (Margin
				   left: 0
				   top: 10
				   right: 0
				   bottom: 0);
		  yourself
]

{ #category : #'as yet unclassified' }
CBLegend >> methodInfo [

	| methodBox methodLabel composite widthLine heightLine |
	methodBox := RSBox new.
	methodLabel := RSLabel new text: 'Method'.
	methodBox extent: methodLabel extent + 10.
	methodBox
		noPaint;
		withBorder.
	widthLine := RSLine new
		             startPoint: 0 @ 0;
		             endPoint: methodBox width @ 0;
		             marker: self marker;
		             yourself.
	heightLine := RSLine new
		              startPoint: 0 @ 0;
		              endPoint: 0 @ methodBox height;
		              marker: self marker;
		              yourself.
	RSVerticalLineLayout new
		gapSize: 5;
		on: { 
				methodBox.
				widthLine }.
	RSHorizontalLineLayout new
		gapSize: 5;
		on: { 
				methodBox.
				heightLine }.
	methodLabel position: methodBox position.
	composite := { 
		             methodBox.
		             methodLabel.
		             widthLine.
		             heightLine } asGroup asShape.
	^ composite
]

{ #category : #interactions }
CBLegend >> onClick [ 
	self class legendState: self class legendState not
]