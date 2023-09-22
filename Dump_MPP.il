; This script converts existing MPP objects back to template
; Note Pins and Nets are lost during convertion, you need to add then manually
procedure(dmDumpMppToTemplate(name) let((obj parts offsetSubPath encSubPath subRect endTypeMapping)
	obj = car(geGetSelSet())
	parts = rodGetObj(obj)->subParts
	offsetSubPath = setof(i parts i->type == "offsetPath")
	encSubPath = setof(i parts i->type == "enclosurePath")
	subRect = setof(i parts i->type == "rectangle")

	endTypeMapping = makeTable("endTypeTable")
	endTypeMapping["truncateExtend"] = "truncate"
	endTypeMapping["extendExtend"] = "extend"
	endTypeMapping["roundRound"] = "round"
	endTypeMapping["varExtendExtend"] = "variable"

	leDefineMPPTemplate(
		?techId			techGetTechFile(obj~>cellView~>lib)
		?name			name
		?layer			obj->lpp
		?width			obj->width
		?choppable		rodIsMasterChoppable(obj)
		?endType			endTypeMapping[obj~>pathStyle]
		?beginExt		obj->beginExt
		?endExt			obj->endExt
		?justification	"center"
		?offset			0.000000
		?offsetSubPath	mapcar(lambda((i) list(
			?layer			i->lpp
			?width			i->width
			?choppable		i->choppable
			?sep				i->separation
			?justification	i->justification
			?beginOffset		i->beginOffset
			?endOffset		i->endOffset
		)) offsetSubPath)
		?encSubPath		mapcar(lambda((i) list(
			?layer			i->lpp
			?enclosure		i->enclosure
			?choppable		i->choppable
			?beginOffset		i->beginOffset
			?endOffset		i->endOffset
		)) encSubPath)
		?subRect		mapcar(lambda((i) list(
			?layer			i->lpp
			?width			i->width
			?length			i->length
			?choppable		i->choppable
			?sep				i->separation
			?justification	i->justification
			?space			i->space
			?beginOffset		i->beginOffset
			?endOffset		i->endOffset
			?beginSegOffset	i->beginSegOffset
			?endSegOffset	i->endSegOffset
			?gap				i->gap
		)) subRect)
	)
))
