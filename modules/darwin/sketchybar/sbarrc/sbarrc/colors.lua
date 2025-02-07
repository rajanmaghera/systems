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
        bg = 0x44000000,
        blur = 10
    },
    popup = {
        bg = 0xc02c2e34,
        border = 0xff7f8490
    },
    unselected_bg1 = 0x00202020,
    unselected_bg2 = 0x22202020,
    unselected_fg1 = 0x44ffffff,
    unselected_fg2 = 0x44ffffff,
    selected_fg1 = 0x22ffffff,
    selected_fg2 = 0xffffffff,
    selected_bg1 = 0x44444444,
    selected_bg2 = 0x44333333,
    bg1 = 0x77363944,
    bg2 = 0x77414550,

    with_alpha = function(color, alpha)
        if alpha > 1.0 or alpha < 0.0 then
            return color
        end
        return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
    end
}
