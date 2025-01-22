let addons = HEMTT_OUT.join("addons");
let prefix_len = HEMTT.project().prefix().len();

for pbo_path in addons.list() {
    let rpbo = pbo_path.file_name();

    // Weapons_CUP_Weapons_ACR.pbo => cup_weapons_acr.pbo
    if rpbo.starts_with("wolf_wolf_") {
        rpbo.crop(prefix_len + 1);
        rpbo.make_lower();
        let rpbo_path = addons.join(rpbo);
        if !pbo_path.move(rpbo_path) {
            fatal("Failed to rename " + pbo_path + " to " + rpbo_path);
        }
    }
}