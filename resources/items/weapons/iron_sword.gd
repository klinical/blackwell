class_name IronSwordResource
extends OneHandedSword


const sprite: CompressedTexture2D = preload("res://sprites/iron_sword.png")
const display: String = "Iron Sword"
const rarity: String = "common"
const model: PackedScene = preload("res://models/Sword(1).glb")
const attack_speed: float =  1.6
const damage: int = 10
const attributes: Dictionary = {
	"stamina": 1,
	"strength": 2
}
