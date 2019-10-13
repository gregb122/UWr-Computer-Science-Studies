def text_compress(raw_text: str) -> str:
    identity_count = 0
    prev_character = raw_text[0]
    compressed_text = ""
    for character in raw_text[1:]:
        if prev_character != character:   # if both characters are different just reassign char to result
            if identity_count > 0:  # if counter of identical chars in sequence > 0, add them to result
                compressed_text += f"{identity_count + 1}"
                identity_count = 0
            compressed_text += prev_character
        else:
            identity_count += 1   # if both characters are the same, just increment identity count
        prev_character = character

    if identity_count > 0:
        compressed_text += f"{identity_count + 1}"
    compressed_text += prev_character

    return compressed_text


print(text_compress('Ale ttttoo już było, i nie wróci więęęęcej'))
print(text_compress('aaaaa'))
print(text_compress('suuuuperrr'))


def text_decompress(compressed_text: str) -> str:
    uncompressed_text = ""
    prev_character = compressed_text[0]
    identity_count = ""
    for character in compressed_text[1:]:
        if prev_character.isdigit():
            identity_count += prev_character
        else:
            if identity_count:
                uncompressed_text += prev_character * (int(identity_count) - 1)
                identity_count = ""
            uncompressed_text += prev_character
        prev_character = character

    if identity_count:
        uncompressed_text += prev_character * (int(identity_count) - 1)
    uncompressed_text += prev_character

    return uncompressed_text


print(text_decompress("s10uper"))
print(text_decompress("10a"))
print(text_decompress('A2l is no3t4ying ma20ter.'))
