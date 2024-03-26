

export function searchData({
  data,
  pageNo,
  sortKey,
  sortOrder,
  totalPosts,
  searchBy,
  searchInp,
  prevSearch
}










) {
  if (!prevSearch.value) pageNo.value = 1;

  prevSearch.value = true;

  const searchedData = [];
  data.forEach((row) => {
    const val = row[searchBy.value];
    if (val === undefined || val === null) return;
    if ((val.toString()).toLowerCase().indexOf(searchInp.value.toLowerCase()) === -1) {
      // do nothing
    } else {
      searchedData.push(row)
    }
  })

  const finalData = searchedData.sort((a, b) => {
    return a[sortKey.value] > b[sortKey.value] ? 1 : -1;
  });

  totalPosts.value = finalData.length;

  if (sortOrder.value === 'dsc') return finalData.reverse();
  return finalData;
}