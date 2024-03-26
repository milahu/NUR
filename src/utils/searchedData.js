

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
  if (!prevSearch.value) pageNo.value = 0;

  prevSearch.value = true;

  const searchedData = [];
  data.forEach((row) => {
    if ((row[searchBy.value].toString()).toLowerCase().indexOf(searchInp.value.toLowerCase()) === -1) {
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