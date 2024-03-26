import { component$, useStylesScoped$, useSignal, useStore, $, useVisibleTask$, useStyles$ } from '@builder.io/qwik';
import { TableHead } from '../tableHead/TableHead';
import { TableBody } from '../tableBody/TableBody';
import { Pagination } from '../Pagination';
import { sortData } from '../../utils/sortData';
import { searchData } from '../../utils/searchedData';
import { Header } from '../header/Header';













export const QwikTable = component$((props) => {
  useStyles$(`
    table {
      border-collapse: collapse;
      width: 100%;
    }
    td {
      padding: 1rem;
      border: 1px solid #e2e8f0;
    }
    tr:hover {
      background: #f8f9fb;
    }`
  );
  useStylesScoped$(AppCSS);

  const sortOrder = useSignal('asc');
  //const sortKey = useSignal(props.header[0].key);
  const sortKey = useSignal(undefined); // perf: dont sort by default
  const pageNo = useSignal(0);
  const postPerPage = useSignal(100);
  const totalPosts = useSignal(props.data.length);
  const searchBy = useSignal(props.header[0].key);
  const searchInp = useSignal('');
  const prevSearch = useSignal(false);

  const finalData = useStore({
    items: props.data
  });

  const sortedData = $(() => sortData({
    data: props.data,
    tableData: finalData.items,
    sortKey: sortKey,
    sortOrder: sortOrder,
    totalPosts: totalPosts,
    prevSearch: prevSearch,
    searchBy: searchBy
  }))

  const searchedData = $(() => searchData({
    data: props.data,
    pageNo: pageNo,
    sortKey: sortKey,
    sortOrder: sortOrder,
    totalPosts: totalPosts,
    searchBy: searchBy,
    searchInp: searchInp,
    prevSearch: prevSearch
  }))

  useVisibleTask$(({ track }) => {
    track(() => sortOrder.value)
    track(() => sortKey.value)
    track(() => pageNo.value)
    track(() => postPerPage.value)
    track(() => searchBy.value)
    track(() => searchInp.value)
    track(() => postPerPage.value)
    track(() => totalPosts.value)
    track(() => prevSearch.value)

    if (searchInp.value === '')
      sortedData().then(res => finalData.items = res);
    else
      searchedData().then(res => finalData.items = res);
  })

  return (
    <div class='table-cont'>
      <Header
        headers={props.header}
        searchBy={searchBy}
        searchInp={searchInp}
        title={props.title}
        headerImg={props.headerImg}
      />

      <Pagination
        pageNo={pageNo}
        postPerPage={postPerPage}
        totalPosts={totalPosts}
      />

      <table>
        <TableHead
          header={props.header}
          sortOrder={sortOrder}
          sortKey={sortKey}
        />
        <TableBody
          data={finalData.items}
          pageNo={pageNo}
          postPerPage={postPerPage} />
      </table>

      <Pagination
        pageNo={pageNo}
        postPerPage={postPerPage}
        totalPosts={totalPosts}
      />
    </div>
  );
});

export const AppCSS = `
  .table-cont {
    margin: 2rem;
    padding-left: 1.5rem;
    padding-right: 1.5rem;
    border: 1px solid #e2e8f0;
    box-shadow: rgba(99, 99, 99, 0.2) 0px 2px 8px 0px;
    border-radius: 8px;
  }
`;
