return {
    black = 0xff181819,
    white = 0xffffffff,
    red = 0xfffc5d7c,
    green = 0xff9ed072,
    blue = 0xff76cce0,
    yellow = 0xffe7c664,
    orange = 0xfff39660,
    magenta = 0xffb39df3,
    grey = 0xff7f8490,
    transparent = 0x00000000,

    bar = {
        bg = 0xff000000
    },
    popup = {
        bg = 0xc02c2e34,
        border = 0xff7f8490
    },
    item_bg1 = 0xFF202020,
    item_bg2 = 0xFF202020,
    -- item_bg = 0xFF202020,
    unselected_fg1 = 0xff7f8490,
    unselected_fg2 = 0xff7f8490,
    -- selected_bg1 = 0xFF075C94,
    selected_fg1 = 0xffffffff,
    selected_fg2 = 0xffffffff,
    selected_bg1 = 0xff444444,
    selected_bg2 = 0xFF333333,
    bg1 = 0xff363944,
    bg2 = 0xff414550,

    with_alpha = function(color, alpha)
        if alpha > 1.0 or alpha < 0.0 then
            return color
        end
        return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
    end
}
