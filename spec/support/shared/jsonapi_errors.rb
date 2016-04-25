shared_examples_for 'JSON API invalid request' do
  context 'when request is invalid' do
    context 'with "include"' do
      context 'when resource does not exist' do
        it 'renders a 400 response' do
          get :index, include: :foobar
          expect(response).to have_http_status :bad_request
          expect(error['title']).to eq('Invalid field')
          expect(error['code']).to eq(112)
        end
      end
    end

    context 'with "fields"' do
      context 'when resource does not exist' do
        it 'renders a 400 response' do
          get :index, fields: { foo: 'bar' }
          expect(response).to have_http_status :bad_request
          expect(error['title']).to eq('Invalid resource')
          expect(error['code']).to eq(101)
        end
      end

      context 'when field does not exist' do
        it 'renders a 400 response' do
          get :index, fields: { users: 'bar' }
          expect(response).to have_http_status :bad_request
          expect(error['title']).to eq('Invalid field')
          expect(error['code']).to eq(104)
        end
      end
    end

    context 'with "filter"' do
      context 'when filter is not allowed' do
        it 'renders a 400 response' do
          get :index, filter: { foo: 'bar' }
          expect(response).to have_http_status :bad_request
          expect(error['title']).to eq('Filter not allowed')
          expect(error['code']).to eq(102)
        end
      end
    end

    context 'with "page"' do
      context 'when using "paged" paginator' do
        context 'with invalid number' do
          it 'renders a 400 response' do
            get :index, page: { number: 'foo' }
            expect(response).to have_http_status :bad_request
            expect(error['title']).to eq('Invalid page value')
            expect(error['code']).to eq(118)
          end
        end

        context 'with invalid size' do
          it 'renders a 400 response' do
            get :index, page: { size: 'foo' }
            expect(response).to have_http_status :bad_request
            expect(error['title']).to eq('Invalid page value')
            expect(error['code']).to eq(118)
          end
        end

        context 'with invalid page param' do
          it 'renders a 400 response' do
            get :index, page: { offset: 1 }
            expect(response).to have_http_status :bad_request
            expect(error['title']).to eq('Page parameter not allowed')
            expect(error['code']).to eq(105)
          end
        end

        context 'with a "size" greater than the max limit' do
          it 'returns the amount of results based on "JSONAPI.configuration.maximum_page_size"' do
            get :index, page: { size: 999 }
            expect(response).to have_http_status :bad_request
            expect(error['title']).to eq('Invalid page value')
            expect(error['code']).to eq(118)
          end
        end
      end

      context 'when using "offset" paginator' do
        before(:all) { UserResource.paginator :offset }

        context 'with invalid offset' do
          it 'renders a 400 response' do
            get :index, page: { offset: -1 }
            expect(response).to have_http_status :bad_request
            expect(error['title']).to eq('Invalid page value')
            expect(error['code']).to eq(118)
          end
        end

        context 'with invalid limit' do
          it 'renders a 400 response' do
            get :index, page: { limit: 'foo' }
            expect(response).to have_http_status :bad_request
            expect(error['title']).to eq('Invalid page value')
            expect(error['code']).to eq(118)
          end
        end

        context 'with invalid page param' do
          it 'renders a 400 response' do
            get :index, page: { size: 1 }
            expect(response).to have_http_status :bad_request
            expect(error['title']).to eq('Page parameter not allowed')
            expect(error['code']).to eq(105)
          end
        end

        context 'with a "size" greater than the max limit' do
          it 'returns the amount of results based on "JSONAPI.configuration.maximum_page_size"' do
            get :index, page: { limit: 999 }
            expect(response).to have_http_status :bad_request
            expect(error['title']).to eq('Invalid page value')
            expect(error['code']).to eq(118)
          end
        end
      end
    end

    context 'with "sort"' do
      context 'when sort criteria is invalid' do
        it 'renders a 400 response' do
          get :index, sort: 'foo'
          expect(response).to have_http_status :bad_request
          expect(error['title']).to eq('Invalid sort criteria')
          expect(error['code']).to eq(114)
        end
      end
    end
  end
end
