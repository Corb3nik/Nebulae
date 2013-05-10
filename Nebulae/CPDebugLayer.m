//
//  CPDebugLayer.m
//
//  Created by Dominique d'Argent on 15.03.12.
//  Copyright 2012. All rights reserved.
//

#import "CPDebugLayer.h"

NSString *const CPDebugLayerDrawShapes = @"drawShapes";
NSString *const CPDebugLayerDrawConstraints = @"drawConstraints";
NSString *const CPDebugLayerDrawBBs = @"drawBBs";
NSString *const CPDebugLayerDrawCollisionPoints = @"drawCollisionPoints";

NSString *const CPDebugLayerShapeColor = @"shapeColor";
NSString *const CPDebugLayerConstraintColor = @"constaintColor";
NSString *const CPDebugLayerBBColor = @"bbColor";
NSString *const CPDebugLayerCollisionPointColor = @"collisionPointColor";

NSString *const CPDebugLayerLineWidth = @"lineWidth";
NSString *const CPDebugLayerPointSize = @"pointSize";

//static void drawColorForPointer(void *ptr) {
//	unsigned long val = (long)ptr;
//	
//	// hash the pointer up nicely
//	val = (val+0x7ed55d16) + (val<<12);
//	val = (val^0xc761c23c) ^ (val>>19);
//	val = (val+0x165667b1) + (val<<5);
//	val = (val+0xd3a2646c) ^ (val<<9);
//	val = (val+0xfd7046c5) + (val<<3);
//	val = (val^0xb55a4f09) ^ (val>>16);
//    
//	GLubyte r = (val>>0) & 0xFF;
//	GLubyte g = (val>>8) & 0xFF;
//	GLubyte b = (val>>16) & 0xFF;
//	
//	GLubyte max = r>g ? (r>b ? r : b) : (g>b ? g : b);
//	
//	const int mult = 127;
//	const int add = 63;
//	r = (r*mult)/max + add;
//	g = (g*mult)/max + add;
//	b = (b*mult)/max + add;
//	
//	ccDrawColor4B(r, g, b, 255);
//}

static void drawCircleShape(cpCircleShape *circle) {
    cpBody *body = ((cpShape *)circle)->body;
    
    // draw
    ccDrawCircle(circle->tc, circle->r, body->a, 32, YES);
}

static void drawSegmentShape(cpSegmentShape *seg) {
    cpFloat radius = seg->r;
    
    if (radius > 0.0f) {
        // multiply line width with segment radius
        cpFloat lineWidth;
        glGetFloatv(GL_LINE_WIDTH, &lineWidth);
        lineWidth *= seg->r;
        
        // set line width
        glLineWidth(lineWidth);
    }
    
    // draw
    ccDrawLine(seg->ta, seg->tb);
    
}

static void drawPolyShape(cpPolyShape *poly) {
    // draw
    ccDrawPoly(poly->tVerts, poly->numVerts, YES);
    
}

static void drawShape(cpShape *shape, void *data) {
    NSDictionary *options = (__bridge NSDictionary *)(data);
    
    // get drawing options
    ccColor4F color = ((CPDebugLayerColor *)[options objectForKey:CPDebugLayerShapeColor]).ccColor4F;
    cpFloat lineWidth = [[options objectForKey:CPDebugLayerLineWidth] floatValue];
    
    // set drawing options
    ccDrawColor4F(color.r, color.g, color.b, color.a);
    glLineWidth(lineWidth);
    
	switch(shape->CP_PRIVATE(klass)->type){
		case CP_CIRCLE_SHAPE:
            drawCircleShape((cpCircleShape *)shape);
			break;
		case CP_SEGMENT_SHAPE:
			drawSegmentShape((cpSegmentShape *)shape);
			break;
		case CP_POLY_SHAPE:
			drawPolyShape((cpPolyShape *)shape);
			break;
		default:
			NSLog(@"Bad enumeration in drawShape().");
	}
}

static void drawSimpleJoint(cpBody *bodyA, cpBody *bodyB, cpVect anchr1, cpVect anchr2, BOOL drawLine) {
    // anchor points in world coordinates
    cpVect a = cpBodyLocal2World(bodyA, anchr1);
    cpVect b = cpBodyLocal2World(bodyB, anchr2);
    
    // draw
    ccDrawPoint(a);
    ccDrawPoint(b);
    
    if (drawLine) {
        ccDrawLine(a, b);
    }
    
}

static void drawSpringJoint(cpDampedSpring *spring, cpBody *bodyA, cpBody *bodyB) {
    static const cpVect verts[] = {
        { 0.00f,  0.0f },
        { 0.20f,  0.0f },
        { 0.25f,  3.0f },
        { 0.30f, -6.0f },
        { 0.35f,  6.0f },
        { 0.40f, -6.0f },
        { 0.45f,  6.0f },
        { 0.50f, -6.0f },
        { 0.55f,  6.0f },
        { 0.60f, -6.0f },
        { 0.65f,  6.0f },
        { 0.70f, -3.0f },
        { 0.75f,  6.0f },
        { 0.80f,  0.0f },
        { 1.00f,  0.0f }
    };
    
    static const int numVerts = sizeof(verts) / sizeof(cpFloat) / 2;
    
    cpVect a = cpBodyLocal2World(bodyA, spring->anchr1);
    cpVect b = cpBodyLocal2World(bodyB, spring->anchr2);

    cpFloat len = cpvlength(cpvsub(b, a));
    cpFloat angle = cpfatan2(b.y - a.y, b.x - a.x);
    
    kmGLMatrixMode(KM_GL_MODELVIEW);
    
    kmGLPushMatrix(); {
        // TODO: use a single matrix
        // scale, rotate and translate
        kmGLTranslatef(a.x, a.y, 0.0f);
        kmGLRotatef(CC_RADIANS_TO_DEGREES(angle), 0.0f, 0.0f, 1.0f);
        kmGLScalef(len, 1.5f, 1.0f);
        
        // draw spring
        ccDrawPoly(verts, numVerts, NO);
        
    } kmGLPopMatrix();
    
    // draw anchor points
    ccDrawPoint(a);
    ccDrawPoint(b);
}

static void drawConstraint(cpConstraint *constraint, void *data) {
    NSDictionary *options = (__bridge NSDictionary *)(data);
    
    // get drawing options
    ccColor4F color = ((CPDebugLayerColor *)[options objectForKey:CPDebugLayerConstraintColor]).ccColor4F;
    cpFloat pointSize = [[options objectForKey:CPDebugLayerPointSize] floatValue];
    cpFloat lineWidth = [[options objectForKey:CPDebugLayerLineWidth] floatValue];
    
    // set drawing options
    ccDrawColor4F(color.r, color.g, color.b, color.a);
    ccPointSize(pointSize);
    glLineWidth(lineWidth);
    
    cpBody *bodyA = constraint->a;
	cpBody *bodyB = constraint->b;
    
    
    
	const cpConstraintClass *klass = constraint->CP_PRIVATE(klass);

	if (klass == cpPinJointGetClass()) {
		cpPinJoint *joint = (cpPinJoint *)constraint;
        
        // draw
        drawSimpleJoint(bodyA, bodyB, joint->anchr1, joint->anchr2, YES);
		
	} else if (klass == cpSlideJointGetClass()) {
		cpSlideJoint *joint = (cpSlideJoint *)constraint;
        
        // draw
        drawSimpleJoint(bodyA, bodyB, joint->anchr1, joint->anchr2, YES);
        
	} else if (klass == cpPivotJointGetClass()) {
		cpPivotJoint *joint = (cpPivotJoint *)constraint;
        
        // draw
        drawSimpleJoint(bodyA, bodyB, joint->anchr1, joint->anchr2, NO);
	} else if (klass == cpGrooveJointGetClass()) {
		cpGrooveJoint *joint = (cpGrooveJoint *)constraint;
        
		cpVect a = cpBodyLocal2World(bodyA, joint->grv_a);
		cpVect b = cpBodyLocal2World(bodyA, joint->grv_b);
		cpVect c = cpBodyLocal2World(bodyB, joint->anchr2);
        
        // draw
		ccDrawPoint(c);
		ccDrawLine(a, b);
	} else if (klass == cpDampedSpringGetClass()){
		drawSpringJoint((cpDampedSpring *)constraint, bodyA, bodyB);
	} else {
        NSLog(@"Cannot draw constraint.");
	}
}

static void drawBB(cpShape *shape, void *data) {
    NSDictionary *options = (__bridge NSDictionary *)(data);
    
    // get drawing options
    ccColor4F color = ((CPDebugLayerColor *)[options objectForKey:CPDebugLayerBBColor]).ccColor4F;
    cpFloat lineWidth = [[options objectForKey:CPDebugLayerLineWidth] floatValue];
    
    // set drawing options
    ccDrawColor4F(color.r, color.g, color.b, color.a);
    glLineWidth(lineWidth);
    
    cpBB bb = shape->bb;
    
    cpVect verts[] = {
		cpv(bb.l, bb.b),
		cpv(bb.l, bb.t),
		cpv(bb.r, bb.t),
		cpv(bb.r, bb.b)
	};
    
    ccDrawPoly(verts, 4, YES);
}

static void drawCollisionPoint(cpVect collisionPoint, void *data) {
    NSDictionary *options = (__bridge NSDictionary *)(data);
    
    // get drawing options
    ccColor4F color = ((CPDebugLayerColor *)[options objectForKey:CPDebugLayerCollisionPointColor]).ccColor4F;
    cpFloat pointSize = [[options objectForKey:CPDebugLayerPointSize] floatValue];
    
    // set drawing options
    ccDrawColor4F(color.r, color.g, color.b, color.a);
    ccPointSize(pointSize);
    
    // draw
    ccDrawPoint(collisionPoint);
    
}

static void drawShapes(cpSpace *space, NSDictionary *options) {
    // draw each shape
    cpSpaceEachShape(space, (cpSpaceShapeIteratorFunc)drawShape, (__bridge void *)(options));
}

static void drawConstraints(cpSpace *space, NSDictionary *options) {
    // draw each constraint
    cpSpaceEachConstraint(space, (cpSpaceConstraintIteratorFunc)drawConstraint, (__bridge void *)(options));
}

static void drawBBs(cpSpace *space, NSDictionary *options) {
    // draw a bounding box for each shape
    cpSpaceEachShape(space, (cpSpaceShapeIteratorFunc)drawBB, (__bridge void *)(options));
}

static void drawCollisionPoints(cpSpace *space, NSDictionary *options) {
    // draw each collision point
    ccArray *arbiters = (ccArray *)space->CP_PRIVATE(arbiters);
    for (int i = 0; i < arbiters->num; i++){
        cpArbiter *arb = (__bridge cpArbiter *)arbiters->arr[i];
        cpContactPointSet contactPointSet = cpArbiterGetContactPointSet(arb);
        
        for (int j = 0; j < contactPointSet.count; j++) {
            drawCollisionPoint(contactPointSet.points[j].point, (__bridge void *)(options));
        }
    }
}


@implementation CPDebugLayerColor

@dynamic ccColor4B;
@dynamic ccColor4F;

+ (id)colorWithR:(cpFloat)r g:(cpFloat)g b:(cpFloat)b a:(cpFloat)a {
    return [[self alloc] initWithR:r g:g b:b a:a];
}

+ (id)colorWithCCColor4B:(ccColor4B)color {
    return [[self alloc] initWithCCColor4B:color];
}

+ (id)colorWithCCColor4F:(ccColor4F)color {
    return [[self alloc] initWithCCColor4F:color];
}

+ (id)colorWithCCColor3B:(ccColor3B)color {
    return [[self alloc] initWithCCColor3B:color];
}

- (id)initWithR:(cpFloat)r g:(cpFloat)g b:(cpFloat)b a:(cpFloat)a {
    self = [super init];
    
    if (self) {
        _r = r;
        _g = g;
        _b = b;
        _a = a;
    }
    
    return self;
}

- (id)initWithCCColor4B:(ccColor4B)color {
    return [self initWithCCColor4F:ccc4FFromccc4B(color)];
}

- (id)initWithCCColor4F:(ccColor4F)color {
    return [self initWithR:color.r g:color.g b:color.b a:color.a];
}

- (id)initWithCCColor3B:(ccColor3B)color {
    return [self initWithCCColor4F:ccc4FFromccc3B(color)];
}

- (ccColor4B)ccColor4B {
    return ccc4((GLubyte) (_r * 255.0f), 
                (GLubyte) (_g * 255.0f), 
                (GLubyte) (_b * 255.0f), 
                (GLubyte) (_a * 255.0f));
}

- (ccColor4F)ccColor4F {
    return ccc4f(_r, _g, _b, _a);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"[%@] (r:%.3f, g:%.3f, b:%.3f, a:%.3f)",
            NSStringFromClass([self class]),
            _r, _g, _b, _a];
}

@end

@implementation CPDebugLayer

@synthesize options = _options;

+ (id)debugLayerForSpace:(cpSpace *)space options:(NSDictionary *)options {
    return [[self alloc] initWithSpace:space options:options];
}

+ (NSDictionary *)defaultOptions {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithBool:YES], CPDebugLayerDrawShapes,
            [NSNumber numberWithBool:YES], CPDebugLayerDrawConstraints,
            [NSNumber numberWithBool:NO], CPDebugLayerDrawBBs,
            [NSNumber numberWithBool:YES], CPDebugLayerDrawCollisionPoints,
            [CPDebugLayerColor colorWithCCColor3B:ccGREEN], CPDebugLayerShapeColor,
            [CPDebugLayerColor colorWithCCColor3B:ccBLUE], CPDebugLayerConstraintColor,
            [CPDebugLayerColor colorWithCCColor3B:ccYELLOW], CPDebugLayerBBColor,
            [CPDebugLayerColor colorWithCCColor3B:ccMAGENTA], CPDebugLayerCollisionPointColor,
            [NSNumber numberWithFloat:2.0f], CPDebugLayerLineWidth,
            [NSNumber numberWithFloat:5.0f], CPDebugLayerPointSize,
            nil];
}

- (id)initWithSpace:(cpSpace *)space options:(NSDictionary *)options {
    self = [super init];
    
    if (self) {
        _space = space;
        
        _options = [[NSDictionary alloc] init];
        [self addOptions:[[self class] defaultOptions]];
        [self addOptions:options];
    }
    
    return self;
}


- (void)draw {
    if ([[_options objectForKey:CPDebugLayerDrawShapes] boolValue]) {
        drawShapes(_space, _options);
    }
    
    if ([[_options objectForKey:CPDebugLayerDrawConstraints] boolValue]) {
        drawConstraints(_space, _options);
    }
    
    if ([[_options objectForKey:CPDebugLayerDrawBBs] boolValue]) {
        drawBBs(_space, _options);
    }
    
    if ([[_options objectForKey:CPDebugLayerDrawCollisionPoints] boolValue]) {
        drawCollisionPoints(_space, _options);
    }
}

- (void)addOptions:(NSDictionary *)options {
    if (options != _options) {
        NSMutableDictionary *tmp = [_options mutableCopy];
        
        [tmp addEntriesFromDictionary:options];
        _options = tmp;
    }
}

@end
