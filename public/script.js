const $addInput = document.getElementById('todo-add-input')
const $list = document.getElementById('list')
const $itemTemplate = document.getElementById('item-template')

const addDeleteHandler = deleteBtn => {
	deleteBtn.addEventListener('click', () => {
		deleteBtn.parentElement.remove()
		requestUpdate()
	})
}

document.querySelectorAll('.item-delete-btn').forEach(addDeleteHandler)

$addInput.addEventListener('keydown', evt => {
	if (evt.key !== 'Enter') return
	if (!$addInput.value) return
	const content = $addInput.value
	$addInput.value = ''
	const $newItem = clone($itemTemplate)
	$newItem.querySelector('.input').value = content
	addDeleteHandler($newItem.querySelector('.item-delete-btn'))
	$list.append($newItem)
	requestUpdate()
})

const requestUpdate = () => {
	const items = [...$list.children]
		.map(child => child.querySelector('.input').value)
	fetch('/items', {
		method: 'POST',
		body: JSON.stringify(items),
	})
}

const clone = template => {
	const fragment = new DocumentFragment()
	fragment.append(...[...template.childNodes].map(x => x.cloneNode(true)))
	return fragment
}
