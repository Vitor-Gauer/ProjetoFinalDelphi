function showDiagramGroup(groupId) {
    const groups = document.querySelectorAll('#group-layouts, #group-conceptual-flows, #group-data-structures, #group-types, #group-architecture');
    groups.forEach(group => group.classList.add('hidden'));

    document.getElementById(groupId).classList.remove('hidden');

    const buttons = document.querySelectorAll('[id^="btn-"]');
    buttons.forEach(btn => {
        btn.classList.remove('bg-purple-600');
        btn.classList.add('bg-gray-800');
    });

    const activeBtn = document.querySelector('#btn-' + groupId.split('-')[1]);
    if (activeBtn) {
        activeBtn.classList.remove('bg-gray-800');
        activeBtn.classList.add('bg-purple-600');
    }
}