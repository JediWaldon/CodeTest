let puzzle = []

let mode_edit = null

/*
*/
document.addEventListener('DOMContentLoaded', () => {

    const mode = document.getElementById('mode')
    mode.addEventListener('change', (e) => {
        const el = e.target
        var value = el.options[el.selectedIndex].value
        const goal_sel = document.getElementById('goal')
        var color = goal_sel.options[goal_sel.selectedIndex].value

        if (value == 'edit') {

            mode_edit = true
            const nodes = document.querySelectorAll(".pzlbtn")

            nodes.forEach(element => {
                if (element.classList.contains('hide')) {
                    element.classList.remove('hide')
                }
                element.classList.remove('red')
                element.classList.remove('blue')
                element.classList.remove('green')
            });

        } else if (value == 'solve') {

            mode_edit = false
            const nodes = document.querySelectorAll(".pzlbtn")
            const node_ids = []

            nodes.forEach(element => {
                if (!element.classList.contains('active')) {
                    element.classList.add('hide')
                } else {
                    element.classList.add(color)
                    node_ids.push(parseInt(element.id))
                }

            });
            const act_nodes = document.querySelectorAll(`.${color}`)

            for (var i = 0; i < node_ids.length; i++) {
                var num = getRndmFromSet(node_ids)
                click_pzl_btn(num)
            }

            while (same_color(act_nodes)) {
                var num = getRndmFromSet(node_ids)
                click_pzl_btn(num)
            }
        }

    });
    create_puzzle();

});

/*
*/
function same_color(nodes) {
    if (nodes.length == 1) {
        return false
    }
    for (var i = 0; i < nodes.length; i++) {
        color = nodes[i].classList[nodes[i].classList.length - 1]

        for (var j = i + 1; j < nodes.length; j++) {
            o_color = nodes[j].classList[nodes[j].classList.length - 1]

            if (color !== o_color) {
                return false
            }
        }
    }
    return true
}

/*
*/
function getRndmFromSet(set) {
    var rndm = Math.floor(Math.random() * set.length);
    return set[rndm];
}

/*
*/
function create_puzzle() {
    let id = 0
    for (id; id < 25; id++) {
        nghbrs = calc_nghbrs(id)
        const pzl_el = { id: id, nghbr_ids: nghbrs };

        puzzle.push(pzl_el);
        create_button(id);


    }
}

/*
*/
function create_button(id) {
    const pzl_btn = document.createElement('button');
    pzl_btn.textContent = `${id}`;
    pzl_btn.classList.add('pzlbtn')
    pzl_btn.classList.add('hide')
    pzl_btn.id = id
    pzl_btn.addEventListener('click', (e) => {
        val = e.target.id
        el = puzzle.find((element) => element.id == val)

        if (mode_edit) {
            if (!e.target.classList.contains('active')) {
                e.target.classList.add('active')
            } else {
                e.target.classList.remove('active')
            }

            el.active = true
        }
        click_pzl_btn(val)
    });
    const pzl = document.getElementById('pzl');
    pzl.appendChild(pzl_btn);
}

/*
*/
function click_pzl_btn(num) {

    if (!mode_edit) {
        change(num)

        puzzle[num].nghbr_ids.forEach(id => {
            change(id)
        })
    }
}

/*
*/
function change(id) {
    const el = document.getElementById(id)
    if (el.classList.contains('inactive')) {

    }
    const c_list = el.classList
    if (el.classList.contains('hide')) {
        return
    } else if (c_list.contains('blue')) {
        el.classList.remove('blue')
        el.classList.add('red')
    } else if (c_list.contains('red')) {
        el.classList.remove('red')
        el.classList.add('green')
    } else if (c_list.contains('green')) {
        el.classList.remove('green')
        el.classList.add('blue')
    }

}

/*
*/
function calc_nghbrs(id) {
    n_list = []
    u_n = id - 5
    d_n = id + 5
    l_n = id - 1
    r_n = id + 1
    if (check_vert_nghbr(u_n) == true) {
        n_list.push(u_n)
    }
    if (check_vert_nghbr(d_n) == true) {
        n_list.push(d_n)
    }
    if (check_hor_nghbr(id, l_n) == true) {
        n_list.push(l_n)
    }
    if (check_hor_nghbr(id, r_n) == true) {
        n_list.push(r_n)
    }

    return n_list
}

/*
*/
function check_vert_nghbr(n_id) {
    if (n_id >= 0 && n_id <= 24) {
        return true
    }
    return false
}

/*
*/
function check_hor_nghbr(id, n_id) {
    if ((n_id % 5 != 0 || id - n_id == 1) && (n_id % 5 != 4 || n_id - id == 1) && n_id <= 24 && n_id >= 0) {
        return true
    }
    return false
}