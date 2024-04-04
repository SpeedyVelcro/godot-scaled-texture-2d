@tool
class_name ScaledTexture2D
extends Texture2D
## Texture that renders at a specific size.
##
## This texture renders the given texture scaled to the given size.

## Source texture to render at a specific scale
@export var texture: Texture2D : set = _set_texture, get = _get_texture
## Size to scale texture to
@export var size := Vector2i(0, 0) : set = _set_size, get = _get_size


func _set_texture(tex: Texture2D) -> void:
	texture = tex
	
	changed.emit()


func _get_texture() -> Texture2D:
	return texture


func _set_size(val: Vector2i) -> void:
	size = val
	
	changed.emit()


## Gets the scaling transform from source texture size to scaled size.
## For the transformation form scaled size to source size, use Transform2D.affine_inverse()
## For further information on matrix transformations see:
## https://docs.godotengine.org/en/stable/tutorials/math/matrices_and_transforms.html
func _get_transform():
	if not size or (size.x == 0) or (size.y == 0):
		return Transform2D()
	
	if not texture:
		return Transform2D()
	
	var trans = Transform2D() # Gives identity transform
	trans.x *= float(size.x) / float(texture.get_width())
	trans.y *= float(size.y) / float(texture.get_height())
	
	return trans


# Override
func _draw(to_canvas_item: RID, pos: Vector2, modulate: Color, transpose: bool) -> void:
	if not size or (size.x == 0) or (size.y == 0):
		return
	
	if not texture:
		return
	
	var tile: bool = false
	RenderingServer.canvas_item_add_texture_rect(
			to_canvas_item,
			Rect2(pos, Vector2(get_width(), get_height())),
			texture.get_rid(),
			tile,
			modulate,
			transpose
	)


# Override
func _draw_rect(to_canvas_item: RID, rect: Rect2, tile: bool, modulate: Color, transpose: bool):
	if not size or (size.x == 0) or (size.y == 0):
		return
	
	if not texture:
		return
	
	RenderingServer.canvas_item_add_texture_rect(
			to_canvas_item,
			rect,
			texture.get_rid(),
			tile,
			modulate,
			transpose
	)


# Override
func _draw_rect_region(to_canvas_item: RID, rect: Rect2, src_rect: Rect2, modulate: Color, transpose: bool, clip_uv: bool):
	if not size or (size.x == 0) or (size.y == 0):
		return
	
	if not texture:
		return
	
	src_rect *= _get_transform().affine_inverse()
	
	RenderingServer.canvas_item_add_texture_rect_region(
			to_canvas_item,
			rect,
			texture,
			src_rect,
			modulate,
			transpose,
			clip_uv
	)


# Override
func _get_size() -> Vector2i:
	return size


# Override
func _get_width() -> int:
	return size.x


# Override
func _get_height() -> int:
	return size.y


# Override
func _has_alpha():
	return texture.has_alpha()


# Override
func _is_pixel_opaque(x: int, y: int):
	# Hacky solution probably doesn't account for blurry pixels on edge after scaling
	
	if not size or (size.x == 0) or (size.y == 0):
		return true
	
	if not texture:
		return true
	
	var scaled_x := int(x * (float(texture.get_width()) / float(size.x)))
	var scaled_y := int(y * (float(texture.get_height()) / float(size.y)))
	
	# Some textures such as CompressedTexture2D seem to not have the method defined
	if texture.has_method("is_pixel_opaque"):
		return texture.is_pixel_opaque(scaled_x, scaled_y)
	elif texture.has_method("_is_pixel_opaque"):
		return texture._is_pixel_opaque(scaled_x, scaled_y)
	
	return true
